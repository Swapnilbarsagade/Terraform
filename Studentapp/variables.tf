variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  default     = "us-east-1a"
}

variable "ubuntu_ami" {
  description = "AMI for Ubuntu instance"
  default     = "ami-12345678" # Replace with the latest Ubuntu AMI ID for your region
}

variable "aws_instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "db_username" {
  description = "Username for RDS instance"
  type        = string
}

variable "db_password" {
  description = "Password for RDS instance"
  type        = string
}
