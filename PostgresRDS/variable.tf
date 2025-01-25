variable "vpc_id" {}

variable "subnet_ids" {
    type = list(string)
}

variable "db_name" {
    default = "employee"
}

variable "db_username" {
    default = "admin"
}

variable "db_password" {
    default = "Redhat@123"
    sensitive = true
}