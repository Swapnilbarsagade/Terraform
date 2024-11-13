
# VPC Configuration
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main-VPC"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                 = aws_vpc.main_vpc.id
  cidr_block             = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
  availability_zone      = var.availability_zone
  tags = {
    Name = "Public-Subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                 = aws_vpc.main_vpc.id
  cidr_block             = var.private_subnet_cidr_block
  availability_zone      = var.availability_zone
  tags = {
    Name = "Private-Subnet"
  }
}

# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Main-IGW"
  }
}

# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Public-RouteTable"
  }
}

# Route for Public Subnet to access Internet
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Security Group for EC2 Instance (Tomcat Web Server)
resource "aws_security_group" "web_server" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-Server-SG"
  }
}

# EC2 Instance for Web Server (Student App with Tomcat 9)
resource "aws_instance" "web_server_instance" {
  ami                    = var.ubuntu_ami
  instance_type          = var.aws_instance_type
  subnet_id              = aws_subnet.public_subnet.id
  security_groups        = [aws_security_group.web_server.name]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx mariadb-server openjdk-11-jdk
              
              # Download and install Tomcat 9
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz -P /tmp
              sudo tar -xzvf /tmp/apache-tomcat-9.0.97.tar.gz -C /opt/
              sudo mv /opt/apache-tomcat-9.0.97 /opt/tomcat9
              sudo chmod +x /opt/tomcat9/bin/*.sh
              
              # Start Nginx and MariaDB services
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo systemctl start mariadb
              sudo systemctl enable mariadb
              
              # Start Tomcat
              sudo /opt/tomcat9/bin/startup.sh
              EOF

  tags = {
    Name = "StudentApp-WebServer"
  }
}

# Security Group for RDS Instance
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}

# RDS Instance in Private Subnet
resource "aws_db_instance" "student_app_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  name                   = "studentappdb"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  skip_final_snapshot    = true
}

# RDS Subnet Group for Private Subnet
resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "rds-private-subnet-group"
  subnet_ids = [aws_subnet.private_subnet.id]
  tags = {
    Name = "RDS-Private-Subnet-Group"
  }
}
