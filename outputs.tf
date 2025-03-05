output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "private_network_id" {
  value = hcloud_network.network.id
}

output "control_plane_ip" {
  value = hcloud_server.control_plane.ipv4_address
}

output "nat_server_id" {
  value = hcloud_server.nat.id
}

output "nat_server_ip" {
  value = hcloud_primary_ip.natipv4.ip_address
}
