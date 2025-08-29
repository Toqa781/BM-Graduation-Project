# Region and AZs
region = "us-west-2"
azs    = ["us-west-2a", "us-west-2b"]

# Networking
vpc_cidr = "10.0.0.0/16"

# EKS
cluster_name         = "stage-eks-cluster"
kubernetes_version   = "1.29"
node_desired_capacity = 2
node_min_capacity     = 1
node_max_capacity     = 3
node_instance_types   = ["t2.small"]

# Key pair
create_key_pair  = true
public_key_path  = "id_rsa.pub"

