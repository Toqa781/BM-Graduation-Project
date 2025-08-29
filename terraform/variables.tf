variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "stage-eks-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.29"
}

variable "node_desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_min_capacity" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_max_capacity" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_instance_types" {
  description = "EC2 instance types for node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "create_key_pair" {
  description = "Whether to create a key pair for SSH access to nodes"
  type        = bool
  default     = true
}

variable "public_key_path" {
  description = "Path to an existing public key file (used if create_key_pair = true)"
  type        = string
  default     = "id_rsa.pub"
}

# Database variables (RDS)
variable "db_engine" {
  description = "Database engine (postgres or mysql)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "16.3"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "db_master_username" {
  description = "Master DB username"
  type        = string
  default     = "appadmin"
}

variable "db_master_password" {
  description = "Master DB password (use Terraform Cloud/Cloud vars or a secrets manager in real projects)"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "DB port (5432 for Postgres, 3306 for MySQL)"
  type        = number
  default     = 5432
}
