# Create a Security Group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow database access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Use cautiously; restrict IPs in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# Create an RDS Subnet Group
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  description = "Subnet group for RDS"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "rds-subnet-group"
  }
}

# Create an RDS Instance
resource "aws_db_instance" "postgres" {
  identifier              = "my-postgres-db"
  allocated_storage       = 20 # Storage in GB
  engine                  = "postgres"
  engine_version          = "15.3" # Replace with your required version
  instance_class          = "db.t3.micro" # Instance type
  name                    = var.db_name "mydatabase" # Database name
  username                = var.db_username "admin" # Master username
  password                = var.db_password "securepassword" # Master password
  parameter_group_name    = "default.postgres15" # Adjust to match your engine version
  publicly_accessible     = false # Set true if you want public access
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  skip_final_snapshot     = true # Avoid snapshot on deletion

  tags = {
    Name = "PostgreSQL-RDS"
    Environment = "Dev"
  }
}


