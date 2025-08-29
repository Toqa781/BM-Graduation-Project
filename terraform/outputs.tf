# VPC Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

# EKS Cluster Outputs
output "eks_cluster_name" {
  value = module.eks.cluster_id       
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_certificate_authority_data" {
  value     = module.eks.cluster_certificate_authority_data
  sensitive = true
}

# Node Group Outputs
output "node_group_role_arn" {
  value = module.eks.managed_node_groups["default"].iam_role_arn  
}
