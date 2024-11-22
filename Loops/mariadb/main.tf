resource "aws_db_instance" "rds_instances" {
  for_each = var.rds_instances

  allocated_storage    = each.value.allocated_storage
  instance_class       = each.value.instance_class
  engine               = "mariadb"
  engine_version       = "10.6" # Specify the desired MariaDB version
  identifier           = "rds-${each.key}" # e.g., rds-prod, rds-dev, rds-test
  username             = each.value.username
  password             = each.value.password
  db_name              = "${each.key}_db"
  publicly_accessible  = true
  skip_final_snapshot  = true
  deletion_protection  = false

  tags = {
    Name        = "${each.key}-rds"
    Environment = each.key
  }
}

output "rds_endpoints" {
  value = {
    for key, instance in aws_db_instance.rds_instances :
    key => instance.endpoint
  }
}