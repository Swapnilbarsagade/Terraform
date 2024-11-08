
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
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.subnet_cidr_1
  map_public_ip_on_launch = true
  tags = {
    Name = "Subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.vpc_2.id
  cidr_block        = var.subnet_cidr_2
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
}

resource "aws_route_table" "rt_2" {
  vpc_id = aws_vpc.vpc_2.id
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

# VPC Peering
resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id        = aws_vpc.vpc_1.id
  peer_vpc_id   = aws_vpc.vpc_2.id
  auto_accept   = true
}

# Routes for VPC Peering
resource "aws_route" "route_vpc_peering_1" {
  route_table_id         = aws_route_table.rt_1.id
  destination_cidr_block = var.vpc_cidr_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "route_vpc_peering_2" {
  route_table_id         = aws_route_table.rt_2.id
  destination_cidr_block = var.vpc_cidr_1
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
}

# EC2 Instances in Each VPC
resource "aws_instance" "instance_1" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_1.id
  security_groups = [aws_security_group.sg_ping.name]
  tags = {
    Name = "Instance-1"
  }
}

resource "aws_instance" "instance_2" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_2.id
  security_groups = [aws_security_group.sg_ping_2.name]
  tags = {
    Name = "Instance-2"
  }
}
