module "vpc" {
  source = "./vpc"
  vpc_cidr = var.vpc_cidr
  availability_zones = var.availability_zones
  cluster_name = var.cluster_name
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs = var.public_subnet_cidrs
}

module "eks" {
  source = "./eks"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  subnets_id = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
  node_groups = var.node_groups
}
