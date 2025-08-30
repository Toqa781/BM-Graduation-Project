variable "vpc_cidr" {
    description = "vpc cidr"
    type = string
    default = "10.0.0.0/16"
}
variable "availability_zones" {
  description = "availability zones"
  type = list(string)
  default = [ "us-west-2a","us-west-2b" ]
}

variable "private_subnet_cidrs" {
  description = "private_subnets_cidrs"
  type = list(string)
  default = [ "10.0.1.0/24","10.0.2.0/24" ]
}

variable "public_subnet_cidrs" {
  description = "public_subnets_cidrs"
  type = list(string)
  default = [ "10.0.3.0/24","10.0.4.0/24" ]
}

variable "cluster_name" {
  description = "eks cluster name"
  type = string
}

variable "cluster_version" {
  description   = "Kubernetes version"
  type          = string

}


variable "node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number 
    })
  }))
}
