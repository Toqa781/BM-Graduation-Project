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
  description = "The name/id of the EKS cluster"
  value       = aws_eks_cluster.stage_eks.id
}

output "node_group_id" {
  description = "EKS node group ID"
  value       = aws_eks_node_group.stage_eks_node_group.id
}

output "subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.the_subnet[*].id
}

output "cluster_token" {
  description = "Token for the EKS cluster"
  value       = data.aws_eks_cluster_auth.stage_eks.token
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = aws_eks_cluster.stage_eks.certificate_authority[0].data
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = aws_security_group.eks_sg.id
}

output "region" {
  description = "AWS region"
  value       = var.region
}