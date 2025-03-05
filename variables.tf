variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

variable "talos_version" {
  description = "Version of Talos to use for the cluster"
  type        = string
  default     = "v1.9.4"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the cluster"
  type        = string
  default     = null
}

variable "controlplane_count" {
  description = "Number of control plane nodes in the cluster"
  type        = number
  default     = 1
}

variable "controlplane_type" {
  description = "Hetzner Cloud instance type for control plane nodes"
  type        = string
  default     = "cax11"
}

variable "location" {
  description = "Hetzner Cloud location for the cluster"
  type        = string
  default     = "fsn1"
}

variable "ip_location" {
  description = "Hetzner Cloud location for the primary IP"
  type        = string
  default     = "fsn1-dc14"
}

variable "network_zone" {
  description = "Network zone for the cluster"
  type        = string
  default     = "eu-central"
}

variable "private_network_range" {
  description = "Private network range for the cluster"
  type        = string
  default     = "10.1.0.0/20"
}

variable "private_network_controlplane_subnet" {
  description = "Private network subnet for managing nodes"
  type        = string
  default     = "10.1.0.0/24"
}

variable "private_network_worker_subnet" {
  description = "Private network subnet for worker nodes"
  type        = string
  default     = "10.1.1.0/24"
}

variable "image_id" {
  description = "Talos image ID to use for the cluster"
  type        = string
}

variable "worker_count" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 3
}

variable "worker_type" {
  description = "Type of worker nodes to create"
  type        = string
  default     = "cax11"
}

variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "nat_server_type" {
  description = "Type of NAT server to create"
  type        = string
  default     = "cax11"
}
