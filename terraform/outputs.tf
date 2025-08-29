output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.stage_eks.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.stage_eks.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.stage_eks.version
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.the_vpc.id
}

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.stage_eks.id
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.nodes_general.id
}

output "subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.the_subnet[*].id
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.allow_tls.id
}

output "region" {
  description = "AWS region"
  value       = var.region
}

