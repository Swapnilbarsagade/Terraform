
variable "aws_region" {
  default = "ap-northeast-2"
}

variable "profile" {
  description = "AWS CLI profile to use"
  default     = "swapnil"
}

variable "vpc_cidr_1" {
  description = "CIDR block for the first VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_cidr_2" {
  description = "CIDR block for the second VPC"
  default     = "10.1.0.0/16"
}

variable "subnet_cidr_1" {
  description = "CIDR block for the subnet in the first VPC"
  default     = "10.0.1.0/24"
}

variable "subnet_cidr_2" {
  description = "CIDR block for the subnet in the second VPC"
  default     = "10.1.1.0/24"
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t2.micro"
}
