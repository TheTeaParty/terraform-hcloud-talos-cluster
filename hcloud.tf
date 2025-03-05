resource "helm_release" "hcloud_ccm" {
  name      = "hcloud-cloud-controller-manager"
  namespace = "kube-system"

  repository = "https://charts.hetzner.cloud"
  chart      = "hcloud-cloud-controller-manager"
  version    = "1.23.0"

  set {
    name  = "networking.enabled"
    value = true
  }

  depends_on = [
    data.http.talos_health
  ]
}

resource "helm_release" "hcloud-csi" {
  name       = "hcloud-csi"
  chart      = "hcloud-csi"
  namespace  = "kube-system"
  repository = "https://charts.hetzner.cloud"
  wait       = true
  version    = "2.12.0"

  depends_on = [
    data.http.talos_health
  ]
}
