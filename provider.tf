terraform {
  required_providers {
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.1"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.50.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=3.4.5"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "kubernetes" {
  host       = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
  client_key = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)

  client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
  cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
}

provider "helm" {
  kubernetes {
    host       = talos_cluster_kubeconfig.this.kubernetes_client_configuration.host
    client_key = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_key)

    client_certificate     = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.client_certificate)
    cluster_ca_certificate = base64decode(talos_cluster_kubeconfig.this.kubernetes_client_configuration.ca_certificate)
  }
}
