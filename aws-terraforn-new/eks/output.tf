output "cluster_name" {
  value       = aws_eks_cluster.eks.name
  description = "EKS Cluster Name"
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "EKS Cluster Endpoint"
}

output "kubernetes_cluster_host" {
  value       = aws_eks_cluster.eks.endpoint
  description = "Kubernetes Cluster Host (same as cluster endpoint)"
}

output "cluster_ca_certificate" {
  value       = aws_eks_cluster.eks.certificate_authority[0].data
  description = "Base64 encoded certificate data for cluster authentication"
}

output "node_group_name" {
  value       = aws_eks_node_group.eks_nodegroup.node_group_name
  description = "EKS Node Group Name"
}
