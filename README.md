# Kubernetes Cluster on Hetzner Cloud
Terraform module to setup a Kubernetes cluster on Hetzner Cloud.

Stack:
- Terraform
- Cilium networking
- Talos

## What's done
- [x] Single node control plane
- [x] Multi node worker
- [x] Cilium networking
- [x] NAT gateway
- [ ] Multi node control plane
- [ ] Autoscaling

## References
Heavily inspired by [kgierke/terraform-hcloud-talos-cluster](https://github.com/kgierke/terraform-hcloud-talos-cluster) big thanks to @kgierke.

Documentation used
- [Creating a cluster via the CLI (hcloud) on Hetzner.
](https://www.talos.dev/v1.9/talos-guides/install/cloud-platforms/hetzner/)
- [Talos example configuration for Hetzner Cloud using terraform](https://github.com/siderolabs/contrib/tree/main/examples/terraform/hcloud)
- [Private network issues](https://github.com/siderolabs/talos/issues/9389)
- [Hetzner cloud csi provider documentation](https://github.com/hetznercloud/csi-driver)
- [Hetzner cloud cloud controller manager documentation](https://github.com/hetznercloud/hcloud-cloud-controller-manager)