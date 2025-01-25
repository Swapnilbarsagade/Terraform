# Output the RDS Endpoint
output "rds_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "PostgreSQL RDS Endpoint"
}