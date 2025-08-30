variable "cluster_name" {
  description = "eks cluster name"
  type = string
}

variable "cluster_version" {
  description = "eks cluster version"
  type = string
}

variable "vpc_id" {
  description = "vpc id"
  type = string
}

variable "subnets_id" {
  description = "subnets ids"
  type = list(string)
}

variable "node_groups" {
  description = "eks cluster node group"
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


