variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "ubuntu_ami_id" {
  description = "AMI ID for Ubuntu"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}


variable "vpc_id" {
  description = "vpc_id"
  type        = string
  
}

variable "public_subnet_ids" {
  description = "public subnet ids"
  type        = list(string)
  
}