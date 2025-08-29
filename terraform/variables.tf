# ==========================
# Provider / Global Settings
# ==========================
variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
  validation {
    condition     = length(var.region) > 0
    error_message = "Region must not be empty."
  }
}

# ============
# Networking
# ============
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

# ============
# EKS Cluster
# ============
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

# ============
# EKS Node Group
# ============
variable "node_instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "node_desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
  default     = 2
}

variable "node_max_capacity" {
  description = "The maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_min_capacity" {
  description = "The minimum number of worker nodes"
  type        = number
  default     = 1
}

# ============
# Access
# ============
variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
