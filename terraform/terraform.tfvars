vpc_cidr = "10.0.0.0/16"
availability_zones = [ "eu-central-1a","eu-central-1b" ]
cluster_name = "sprints-cluster"
private_subnet_cidrs = [ "10.0.1.0/24","10.0.2.0/24" ]
public_subnet_cidrs = [ "10.0.3.0/24","10.0.4.0/24" ]

cluster_version = "1.30"
node_groups = {
  "default" = {
    instance_types = [ "t3.micro" ]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      desired_size = 2
      max_size = 3
      min_size = 2
    }
  }
}
