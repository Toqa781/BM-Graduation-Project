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
  default     = ["t2.small"]
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

