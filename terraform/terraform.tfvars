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
node_instance_types   = ["t3.medium"]

# Key pair
create_key_pair  = true
public_key_path  = "id_rsa.pub"

# RDS
db_engine           = "postgres"
db_engine_version   = "16.3"
db_instance_class   = "db.t3.micro"
db_name             = "appdb"
db_master_username  = "appadmin"
# IMPORTANT: set this via -var or environment, not committed to VCS
# db_master_password = "YOUR-STRONG-PASSWORD"
db_port             = 5432
