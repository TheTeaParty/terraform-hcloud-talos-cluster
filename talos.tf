resource "talos_machine_secrets" "this" {
  talos_version = var.talos_version
}

data "talos_machine_configuration" "control_plane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${hcloud_primary_ip.control_plane.ip_address}:6443"
  machine_type     = "controlplane"
  talos_version    = var.talos_version
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    templatefile("${path.module}/templates/controlplanepatch.yaml.tmpl", {
      subnet               = var.private_network_range
      endpoint             = hcloud_primary_ip.control_plane.ip_address
      hcloud_token_encoded = base64encode(var.hcloud_token)
      network_id_encoded   = base64encode(hcloud_network.network.id)
    })
  ]

  depends_on = [
    hcloud_primary_ip.control_plane
  ]
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${hcloud_primary_ip.control_plane.ip_address}:6443"
  machine_type     = "worker"
  talos_version    = var.talos_version
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = [
    templatefile("${path.module}/templates/workerpatch.yaml.tmpl", {
      subnet   = hcloud_network.network.ip_range
      endpoint = hcloud_primary_ip.control_plane.ip_address
      gateway  = cidrhost(hcloud_network.network.ip_range, 1)
    })
  ]

  depends_on = [
    hcloud_primary_ip.control_plane
  ]

}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = hcloud_primary_ip.control_plane.ip_address
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints = [
    hcloud_server.control_plane.ipv4_address
  ]
}
