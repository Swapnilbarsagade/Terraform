variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr_a" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_cidr_b" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "private_subnet_cidr_a" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_cidr_b" {
  description = "CIDR block for private subnet B"
  type        = string
}

variable "availability_zone_a" {
  description = "Availability Zone for subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability Zone for subnet B"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
}

variable "public_subnet_name" {
  description = "Name prefix for public subnets"
  type        = string
}

variable "private_subnet_name" {
  description = "Name prefix for private subnets"
  type        = string
}

variable "public_rt_name" {
  description = "Name of the Public Route Table"
  type        = string
}

variable "private_rt_name" {
  description = "Name of the Private Route Table"
  type        = string
}
