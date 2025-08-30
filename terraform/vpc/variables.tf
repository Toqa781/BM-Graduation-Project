variable "vpc_cidr" {
  description = "CIDR Block for the vpc"
  type = string
}

variable "private_subnet_cidrs" {
  description = "CIDR Block for the private subnets"
  type = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR Block for the public subnets"
  type = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type = list(string)
}

variable "cluster_name" {
  description = "eks cluster name"
  type = string
}
