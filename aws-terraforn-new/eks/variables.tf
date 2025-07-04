variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS and worker nodes"
}

variable "cluster_sg_id" {
  type        = string
  description = "Security group ID for EKS control plane"
}

variable "node_sg_id" {
  type        = string
  description = "Security group ID for EKS worker nodes"
}

variable "ssh_key_name" {
  type        = string
  description = "SSH key pair name for worker nodes"
}

variable "ebs_csi_driver_version" {
  type        = string
  default     = "v1.40.1-eksbuild.1"
}