resource "aws_vpc" "the_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "the_vpc"
  }
}

resource "aws_subnet" "the_subnet" {
  count = 2
  vpc_id                  = aws_vpc.the_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.the_vpc.cidr_block, 8, count.index)
  availability_zone       = element(["us-east-1a", "us-east-1b"], count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "the_subnet-${count.index}"
  }
}


resource "aws_internet_gateway" "stage_igw" {
  vpc_id = aws_vpc.the_vpc.id

  tags = {
    Name = "stage_igw"
  }
}

resource "aws_route_table" "stage_route" {
  vpc_id = aws_vpc.the_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.stage_igw.id
  }

  tags = {
    Name = "stage_route"
  }
}



resource "aws_route_table_association" "public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.the_subnet[count.index].id
  route_table_id = aws_route_table.stage_route.id
}



resource "aws_security_group" "eks_sg" {
  name        = "stage_sg"
  description = "Security group for EKS cluster"
  vpc_id = aws_vpc.the_vpc.id

  ingress {
    from_port   = 0
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "eks_ssh_keynew"
  public_key = file(var.public_key_path) 
}

resource "aws_iam_role" "eks_worker_node_role" {
  name = "stage-eks-worker-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "worker_cni_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ec2_read_only_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ec2_full_access_policy" {
  role       = aws_iam_role.eks_worker_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"  
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "stage-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_eks_cluster" "stage_eks" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.stage_subnet[*].id
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_eks_node_group" "stage_eks_node_group" {
  cluster_name    = aws_eks_cluster.stage_eks.name
  node_group_name = "stage-eks-node-group"
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn
  subnet_ids      = aws_subnet.the_subnet[*].id

  scaling_config {
    desired_size = var.node_desired_capacity
    max_size     = var.node_max_capacity
    min_size     = var.node_min_capacity
  }

  instance_types = ["t3.micro"] 

  remote_access {
    ec2_ssh_key = aws_key_pair.ssh_key.key_name
    source_security_group_ids = [aws_security_group.eks_sg.id]
  }

}


data "aws_eks_cluster" "stage_eks" {
  name = aws_eks_cluster.stage_eks.name
}

data "aws_eks_cluster_auth" "stage_eks" {
  name = aws_eks_cluster.stage_eks.name
}