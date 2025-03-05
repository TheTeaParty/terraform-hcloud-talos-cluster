resource "hcloud_primary_ip" "control_plane" {
  name              = "control-plane"
  datacenter        = var.ip_location
  type              = "ipv4"
  auto_delete       = false
  delete_protection = true
  assignee_type     = "server"
}

resource "hcloud_placement_group" "control_plane" {
  name = "controlplane"
  type = "spread"
}

resource "hcloud_server" "control_plane" {
  name        = "control-plane"
  image       = var.image_id
  server_type = var.controlplane_type
  location    = var.location

  labels = {
    type = "k8s",
    role = "controlplane",
    os   = "talos"
  }

  network {
    network_id = hcloud_network.network.id
    ip         = cidrhost(hcloud_network_subnet.control_plane.ip_range, 3)
    alias_ips  = []
  }

  firewall_ids = [
    hcloud_firewall.default.id
  ]

  public_net {
    ipv4 = hcloud_primary_ip.control_plane.id
  }

  user_data = data.talos_machine_configuration.control_plane.machine_configuration

  depends_on = [
    hcloud_network.network,
    hcloud_network_subnet.control_plane,
    hcloud_primary_ip.control_plane
  ]
}

resource "talos_machine_bootstrap" "bootstrap" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_primary_ip.control_plane.ip_address
  node                 = hcloud_primary_ip.control_plane.ip_address

  depends_on = [
    hcloud_server.control_plane
  ]
}
