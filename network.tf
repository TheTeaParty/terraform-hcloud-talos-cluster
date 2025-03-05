resource "hcloud_network" "network" {
  name     = var.cluster_name
  ip_range = var.private_network_range
}

resource "hcloud_network_subnet" "control_plane" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.private_network_controlplane_subnet
}

resource "hcloud_network_subnet" "worker" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.private_network_worker_subnet
}
