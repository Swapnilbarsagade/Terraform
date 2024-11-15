variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  default     = "vpc-03276f1b3bce97eec"
}


# EC2 variables for studentapp: ---

variable "this_ami" {
  description = "Type of the instance to launch"
  type        = string
  default     = "ami-042e76978adeb8c48"
}

variable "instance_type" {
  description = "Type of the instance to launch"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for the instance"
  type        = string
  default     = "batmobile"
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address"
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "availability_zone" {
  description = "Availability zone to launch the instance"
  type        = string
  default     = "default"
}

variable "this_aws_instance_volume_size" {
  description = "this_aws_instance_volume_size for instance"
  type        = number
  default     =  10
}