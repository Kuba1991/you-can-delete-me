# AWS Region
variable "aws_region" {
  description = "The AWS region to create resources in"
  default     = "eu-west-1"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Subnet CIDR Blocks
variable "subnet_a_cidr" {
  description = "CIDR block for Subnet A"
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR block for Subnet B"
  default     = "10.0.2.0/24"
}

# Cluster name
variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "my-cluster"
}

# Instance type for worker nodes
variable "worker_instance_type" {
  description = "EC2 instance type for worker nodes"
  default     = "t3.medium"  # or any other instance type of your choice
}
