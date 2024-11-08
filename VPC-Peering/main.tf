# main.tf

# AWS provider configuration
provider "aws" {
  profile = var.profile
  region  = var.region
}

# Create the first VPC
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_a_name
  }
}

# Create the second VPC
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_b_name
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer_ab" {
  vpc_id        = aws_vpc.vpc_a.id
  peer_vpc_id   = aws_vpc.vpc_b.id
  peer_region   = var.region

  tags = {
    Name = "${var.vpc_a_name}-to-${var.vpc_b_name}-peering"
  }
}

# Route for VPC-A to VPC-B
resource "aws_route" "vpc_a_to_vpc_b" {
  route_table_id         = aws_vpc.vpc_a.main_route_table_id
  destination_cidr_block = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_ab.id
}

# Route for VPC-B to VPC-A
resource "aws_route" "vpc_b_to_vpc_a" {
  route_table_id         = aws_vpc.vpc_b.main_route_table_id
  destination_cidr_block = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer_ab.id
}
