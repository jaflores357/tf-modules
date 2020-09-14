variable "module_version" {
  description = "Module Version"
  default     = "master"
}

variable "cluster_name" {
    description = "EKS Cluster Name"
}

variable "aws_region" {
    description = "EKS Cluster Name"
}

variable "private_subnets" {
    description = "CIDR of private subnet of vpc"
    type        = list
}

variable "vpc_id" {
    description = "VPC ID"
}

variable "tags" {
    description = "Network Tags"
    type        = map
    default     = {}
}

variable "worker_groups" {
    description = "Worker Groups definition"
    type        = list

}

variable "domains" {
    description = "External domains"
    type        = list
}

locals {
    workers_role_name = "${var.cluster_name}-workers-role"
    module_tags       = {
        "terraform.module"         = "vpc"
        "terraform.module.version" = var.module_version
    }
    
}
