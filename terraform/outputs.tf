output "eks_cluster_name" {
  value = aws_eks_cluster.stage_eks.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.stage_eks.endpoint
}

output "vpc_id" {
  value = aws_vpc.stage_vpc.id
}


output "cluster_id" {
  value = aws_eks_cluster.stage_eks.id
}

output "node_group_id" {
  value = aws_eks_node_group.stage_eks_node_group.id
}


output "subnet_ids" {
  value = aws_subnet.stage_subnet[*].id
}


output "cluster_token" {
  value = data.aws_eks_cluster_auth.stage_eks.token
  sensitive = true
}