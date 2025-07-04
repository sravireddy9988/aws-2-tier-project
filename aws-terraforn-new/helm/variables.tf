variable "kubernetes_cluster_host" {
  description = "The endpoint of the EKS cluster"
  type        = string
}

variable "cluster_ca_certificate" {
  description = "Base64-encoded CA certificate of the cluster"
  type        = string
}

variable "access_token" {
  description = "Short-lived authentication token for EKS"
  type        = string
}

variable "namespace" {
  type        = string
  default     = "my-app"
  description = "Namespace to deploy the Helm chart"
}

variable "release_name" {
  type        = string
  default     = "my-release"
  description = "Helm release name"
}

variable "helm_repo" {
  type        = string
  default     = "https://charts.bitnami.com/bitnami"
  description = "Helm repository URL"
}

variable "helmchart_name" {
  type        = string
  default     = "nginx"
  description = "Helm chart name"
}

variable "helmchart_version" {
  type        = string
  default     = "15.2.2"
  description = "Helm chart version"
}
