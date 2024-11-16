output "rds_endpoint" {
  value = aws_db_instance.studentdb.endpoint
}

output "rds_instance_id" {
  value = aws_db_instance.studentdb.id
}