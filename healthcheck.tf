data "http" "talos_health" {
  url      = "https://${hcloud_primary_ip.control_plane.ip_address}:6443/version"
  insecure = true

  retry {
    attempts     = 10
    min_delay_ms = 5000
    max_delay_ms = 5000
  }

  depends_on = [
    talos_machine_bootstrap.bootstrap
  ]
}