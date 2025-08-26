variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "node_instance_type" {
  description = "The instance type for the EKS nodes"
  type        = string
}

variable "node_desired_capacity" {
  description = "The desired number of worker nodes"
  type        = number
}

variable "node_max_capacity" {
  description = "The maximum number of worker nodes"
  type        = number
}

variable "node_min_capacity" {
  description = "The minimum number of worker nodes"
  type        = number
}

variable "public_key_path" {
  description = "Path to your public SSH key"
  type        = string
  default     = "id_rsa.pub" # Relative path to the key file
}
