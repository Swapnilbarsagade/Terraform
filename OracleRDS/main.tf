provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

# Oracle RDS Instance
resource "aws_db_instance" "oracle_db" {
  identifier              = var.db_identifier
  allocated_storage       = var.db_allocated_storage
  engine                  = "oracle-se2"       # Or "oracle-se1", "oracle-ee" depending on your needs
  instance_class          = var.db_instance_class
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = var.db_parameter_group
  skip_final_snapshot     = true
  publicly_accessible     = var.publicly_accessible
  backup_retention_period = var.backup_retention_period

  # Optional: Multi-AZ setup
  multi_az = var.multi_az
}

# Output database endpoint
output "db_endpoint" {
  value = aws_db_instance.oracle_db.endpoint
}

output "db_arn" {
  value = aws_db_instance.oracle_db.arn
}
