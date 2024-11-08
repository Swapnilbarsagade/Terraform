# variables.tf
variable "profile" {
  description = "AWS CLI profile to use"
  default     = "default"
}

variable "region" {
  description = "AWS region to deploy resources"
  default     = "ap-northeast-2"
}

variable "vpc_a_cidr" {
  description = "CIDR block for the first VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_b_cidr" {
  description = "CIDR block for the second VPC"
  default     = "10.1.0.0/16"
}

variable "vpc_a_name" {
  description = "Name tag for the first VPC"
  default     = "VPC-A"
}

variable "vpc_b_name" {
  description = "Name tag for the second VPC"
  default     = "VPC-B"
}
