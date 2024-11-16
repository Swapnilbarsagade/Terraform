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

variable "vpc_id" {
  description = "The VPC ID to associate with the security group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  default = ["subnet-07d50e514206d0408", "subnet-0cb026ebf3a0bf22e", "subnet-0a7d16e970a6d7b9f", "subnet-0c695957469386d8e"]
}

