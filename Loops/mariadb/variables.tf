# Define the configurations for each RDS instance
variable "rds_instances" {
  default = {
    prod = {
      instance_class = "db.t3.large"
      allocated_storage = 20
      username = "admin_prod"
      password = "password_prod"
    }
    dev = {
      instance_class = "db.t3.small"
      allocated_storage = 10
      username = "admin_dev"
      password = "password_dev"
    }
    test = {
      instance_class = "db.t3.micro"
      allocated_storage = 5
      username = "admin_test"
      password = "password_test"
    }
  }
}