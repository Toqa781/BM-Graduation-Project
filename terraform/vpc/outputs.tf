output "vpc_id" {
    description = "VPC ID"
    value = aws_vpc.main.id
}

output "private_subnet_ids" {
    description = "private subnets ids"
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
    description = "public subnets ids"
  value = aws_subnet.public_subnets[*].id
}