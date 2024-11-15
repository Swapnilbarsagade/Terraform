variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
}


# EC2 variables for studentapp: ---

variable "this_ami" {
  description = "Type of the instance to launch"
  type        = string
  default     = "t3.micro"
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

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = [aws_security_group.this_student_sg.id]  # Replace with actual IDs
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