variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnets"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name tag for the Internet Gateway"
  type        = string
}

variable "public_subnet_name" {
  description = "Name tag for the public subnet"
  type        = string
}

variable "private_subnet_name" {
  description = "Name tag for the private subnet"
  type        = string
}

variable "public_rt_name" {
  description = "Name tag for the public route table"
  type        = string
}

variable "private_rt_name" {
  description = "Name tag for the private route table"
  type        = string
}
