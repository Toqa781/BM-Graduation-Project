resource "aws_subnet" "private_subnets" {
  count= length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags={
    Name="${var.cluster_name}-private-subnet-${count.index+1}"
    "kubernetes.io/cluster/${var.cluster_name}"         =   "shared"
    "kubernetes.io/role/internal-elb"                   =   "1"
  }
}


resource "aws_subnet" "public_subnets" {
  count= length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags={
    Name="${var.cluster_name}-public-subnet-${count.index+1}"
    "kubernetes.io/cluster/${var.cluster_name}"         =   "shared"
    "kubernetes.io/role/elb"                            =   "1"
  }
}
