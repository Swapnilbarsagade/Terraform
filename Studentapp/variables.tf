variable "ubuntu_ami" {
  description = "AMI for Ubuntu instance"
  default     = "ami-042e76978adeb8c48" # Replace with the latest Ubuntu AMI ID for your region
}

variable "aws_instance_type" {
  description = "Instance type for EC2"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
  default      = "batmobile"
}


