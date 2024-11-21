output "db_endpoint" {
  description = "RDS instance endpoint for database connections"
  value       = aws_db_instance.mariadb.endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mariadb.port
}

output "db_name" {
  description = "Name of the database in RDS"
  value       = var.db_name
}

output "db_username" {
  description = "Username for the RDS database"
  value       = var.db_username
}

output "db_password" {
  description = "Password for the RDS database"
  sensitive   = true
  value       = var.db_password
}
