provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

# First VPC
resource "aws_vpc" "vpc_1" {
  cidr_block           = var.vpc_cidr_1
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-1"
  }
}

# Second VPC
resource "aws_vpc" "vpc_2" {
  cidr_block           = var.vpc_cidr_2
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC-2"
  }
}

# Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id                 = aws_vpc.vpc_1.id
  cidr_block             = var.subnet_cidr_1
  availability_zone      = "ap-northeast-2c"  # Ensure this matches the AZ you want
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id                 = aws_vpc.vpc_2.id
  cidr_block             = var.subnet_cidr_2
  availability_zone      = "ap-northeast-2c"  # Ensure this matches the AZ you want
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-2"
  }
}

# Internet Gateways
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = {
    Name = "IGW-1"
  }
}

resource "aws_internet_gateway" "igw_2" {
  vpc_id = aws_vpc.vpc_2.id
  tags = {
    Name = "IGW-2"
  }
}

# Route Tables
resource "aws_route_table" "rt_1" {
  vpc_id = aws_vpc.vpc_1.id
  tags = {
    Name = "RouteTable-1"
  }
}

resource "aws_route_table" "rt_2" {
  vpc_id = aws_vpc.vpc_2.id
  tags = {
    Name = "RouteTable-2"
  }
}

# Routes for Internet Access
resource "aws_route" "route_igw_1" {
  route_table_id         = aws_route_table.rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_1.id
}

resource "aws_route" "route_igw_2" {
  route_table_id         = aws_route_table.rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_2.id
}

# Associate Route Tables with Subnets
resource "aws_route_table_association" "rta_1" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.rt_1.id
}

resource "aws_route_table_association" "rta_2" {
  subnet_id      = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.rt_2.id
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id        = aws_vpc.vpc_1.id
  peer_vpc_id   = aws_vpc.vpc_2.id
  auto_accept   = true
  tags = {
    Name = "VPC-Peering"
  }
}

# Routes for VPC Peering
resource "aws_route" "route_vpc_peering_1" {
  route_table_id            = aws_route_table.rt_1.id
  destination_cidr_block    = var.vpc_cidr_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_vpc_peering_2" {
  route_table_id            = aws_route_table.rt_2.id
  destination_cidr_block    = var.vpc_cidr_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

# Security Groups
resource "aws_security_group" "sg_ping" {
  vpc_id = aws_vpc.vpc_1.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_2.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-Ping-1"
  }
}

resource "aws_security_group" "sg_ping_2" {
  vpc_id = aws_vpc.vpc_2.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-Ping-2"
  }
}

# EC2 Instances
resource "aws_instance" "instance_1" {
  ami                    = "ami-03d31e4041396b53c" # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_1.id
  availability_zone      = "ap-northeast-2c"  # Ensure this matches the subnet's AZ
  vpc_security_group_ids = [aws_security_group.sg_ping.id]  # Corrected argument name
  tags = {
    Name = "Server-1"
  }
}

resource "aws_instance" "instance_2" {
  ami                    = "ami-03d31e4041396b53c" # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_2.id
  availability_zone      = "ap-northeast-2c"  # Ensure this matches the subnet's AZ
  vpc_security_group_ids = [aws_security_group.sg_ping_2.id]  # Corrected argument name
  tags = {
    Name = "Server-2"
  }
}
