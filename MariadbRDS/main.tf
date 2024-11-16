# VPC Security Group
resource "aws_security_group" "rds_sg" {
  name        = "rds_security_group"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow MySQL traffic"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Consider restricting this IP range
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# DB Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids  # Replace with your subnet IDs

  tags = {
    Name = "rds-subnet-group"
  }
}

# RDS Instance

resource "aws_db_instance" "studentdb" {
  identifier        = var.db_identifier
  engine            = var.db_engine
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = var.allocated_storage   # Size in GB

  username = var.db_username
  password = var.db_password
  db_name  = var.db_name

  skip_final_snapshot = var.skip_final_snapshot     # Set to false if you want a final snapshot before deletion

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  multi_az            = var.multi_az    # Set to true for multi-AZ deployments
  storage_type        = var.storage_type  # General Purpose SSD
  publicly_accessible = var.publicly_accessible  # Set to true if you want the instance to be publicly accessible

  tags = {
    Name = "MyRDSInstance"
  }

  final_snapshot_identifier = var.final_snapshot_identifier  # Optional, if you want a snapshot before deletion
}

