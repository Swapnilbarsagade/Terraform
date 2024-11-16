# VPC network for Studentapp

variable "vpc_id" {
  description = "VPC ID where the security group will be created"
  type        = string
  default     = "vpc-03276f1b3bce97eec"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
  default = ["subnet-07d50e514206d0408", "subnet-0cb026ebf3a0bf22e", "subnet-0a7d16e970a6d7b9f", "subnet-0c695957469386d8e"]
}

# EC2 variables for studentapp: 

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

variable "domain_name" {
  description = "The domain name registered in Route 53"
  type        = string
  default     = "swapnilbdevops.online"
}

variable "subdomain" {
  description = "Subdomain for the carvcilla app"
  type        = string
  default     = "student.swapnilbdevops.online"  # Example subdomain (e.g., 'todo.example.com')
}


# RDS instance variables

variable "db_identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = "my-rds-instance"
}

variable "db_engine" {
  description = "The database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "The version of the database engine"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "The allocated storage size in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "The master username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "The master password for the RDS instance"
  type        = string
  sensitive   = true  # Marked as sensitive to avoid output in logs
}

variable "db_name" {
  description = "The name of the initial database to create"
  type        = string
  default     = "mydb"
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the DB instance"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Whether to enable multi-AZ deployment for high availability"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The storage type for the RDS instance"
  type        = string
  default     = "gp2"
}

variable "publicly_accessible" {
  description = "Whether the RDS instance is publicly accessible"
  type        = bool
  default     = false
}

variable "final_snapshot_identifier" {
  description = "The final snapshot identifier if snapshot is enabled"
  type        = string
  default     = "my-rds-instance-final-snapshot"
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}
