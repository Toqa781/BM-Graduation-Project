########################
# Networking (VPC)    #
########################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr

  azs             = length(var.azs) > 0 ? var.azs : slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets  = [for i in range(2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i in range(2, 4) : cidrsubnet(var.vpc_cidr, 8, i)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Project = var.cluster_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

########################
# SSH Key (optional)   #
########################

resource "aws_key_pair" "this" {
  count      = var.create_key_pair ? 1 : 0
  key_name   = "${var.cluster_name}-key"
  public_key = file(var.public_key_path)
}

########################
# EKS Cluster          #
########################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.5"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  create_key_pair = false   

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      min_size     = var.node_min_capacity
      max_size     = var.node_max_capacity
      desired_size = var.node_desired_capacity

      instance_types = var.node_instance_types
      capacity_type  = "ON_DEMAND"

      remote_access = var.create_key_pair ? {
        ec2_ssh_key               = aws_key_pair.this[0].key_name
        source_security_group_ids = [aws_security_group.node_ssh_sg.id]
      } : null
    }
  }

  tags = {
    Project = var.cluster_name
  }
}



# Security group to allow SSH to nodes if remote access is enabled
resource "aws_security_group" "node_ssh_sg" {
  name        = "${var.cluster_name}-node-ssh"
  description = "Allow SSH access to EKS nodes (optional)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
