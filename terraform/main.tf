#################################
# VPC
#################################
resource "aws_vpc" "the_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "eks-vpc"
    Environment = var.env
  }
}

resource "aws_subnet" "the_subnet" {
  count             = 3 # High availability across 3 AZs
  vpc_id            = aws_vpc.the_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name        = "eks-subnet-${count.index}"
    Environment = var.env
  }
}

resource "aws_internet_gateway" "the_gw" {
  vpc_id = aws_vpc.the_vpc.id
}

resource "aws_route_table" "the_routing_table" {
  vpc_id = aws_vpc.the_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.the_gw.id
  }
}

resource "aws_route_table_association" "the_association" {
  count          = 3
  subnet_id      = aws_subnet.the_subnet[count.index].id
  route_table_id = aws_route_table.the_routing_table.id
}

#################################
# Security Group
#################################
resource "aws_security_group" "allow_tls" {
  name   = "allow_tls"
  vpc_id = aws_vpc.the_vpc.id

  # Limit SSH to your IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip] # safer than 0.0.0.0/0
  }

  # Allow HTTP/HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Worker-to-worker communication
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#################################
# EKS Cluster IAM Role
#################################
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"

  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

#################################
# EKS Cluster
#################################
resource "aws_eks_cluster" "stage_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids         = aws_subnet.the_subnet[*].id
    security_group_ids = [aws_security_group.allow_tls.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy]
}

#################################
# Node Group
#################################
resource "aws_iam_role" "nodes_general" {
  name = "eks-node-group-nodes-general"

  assume_role_policy = data.aws_iam_policy_document.nodes_assume_role.json
}

data "aws_iam_policy_document" "nodes_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "nodes_general_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy" # added logging
  ])
  role       = aws_iam_role.nodes_general.name
  policy_arn = each.value
}

resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.stage_eks.name
  node_group_name = "nodes-general"
  node_role_arn   = aws_iam_role.nodes_general.arn
  subnet_ids      = aws_subnet.the_subnet[*].id
  instance_types  = [var.node_instance_type]
  disk_size       = 20

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_iam_role_policy_attachment.nodes_general_policies]
}
