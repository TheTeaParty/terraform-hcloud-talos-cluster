resource "hcloud_placement_group" "worker" {
  name = "worker"
  type = "spread"
}

resource "hcloud_server" "worker" {
  count              = var.worker_count
  name               = "worker-${count.index}"
  image              = var.image_id
  server_type        = var.worker_type
  location           = var.location
  labels = {
    type = "k8s",
    role = "worker",
    os   = "talos"
  }
  placement_group_id = hcloud_placement_group.worker.id

  network {
    network_id = hcloud_network.network.id
    ip         = cidrhost(hcloud_network_subnet.worker.ip_range, 2 + count.index)
    alias_ips  = []
  }

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

  user_data = data.talos_machine_configuration.worker.machine_configuration

  depends_on = [
    hcloud_network.network,
    hcloud_network_subnet.worker
  ]
}
