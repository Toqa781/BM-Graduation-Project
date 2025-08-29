region                = "us-east-1"
vpc_cidr              = "10.0.0.0/16"
private_subnets       = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets        = ["10.0.3.0/24", "10.0.4.0/24"]

cluster_name          = "stage-eks-cluster"
cluster_version       = "1.30"   # or latest available EKS version

node_instance_type    = "t3.micro"
node_desired_capacity = 2
node_max_capacity     = 3
node_min_capacity     = 1

public_key_path       = "id_rsa.pub"

# new variables we added for consistency
env                   = "stage"
my_ip                 = "0.0.0.0/0"   # 👈 temporary open access, better to restrict later
