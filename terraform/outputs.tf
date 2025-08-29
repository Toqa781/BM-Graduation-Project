output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  value       = aws_eks_cluster.eks.version
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "cluster_id" {
  description = "The ID of the EKS cluster"
  value       = aws_eks_cluster.eks.id
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.eks_nodes.id
}

output "subnet_ids" {
  description = "List of IDs of the subnets"
  value       = [aws_subnet.public[*].id, aws_subnet.private[*].id]
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.eks_sg.id
}

output "region" {
  description = "AWS region"
  value       = var.region
}
