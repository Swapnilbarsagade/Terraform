module "vpc" {
  source               = "/home/cloudshell-user/Terraform/ModuleBlock/Resources/VPC"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  private_subnet_cidr  = "10.0.2.0/24"
  availability_zone    = "ap-northeast-2a"
  vpc_name             = "main-vpc"
  igw_name             = "main-igw"
  public_subnet_name   = "public-subnet"
  private_subnet_name  = "private-subnet"
  public_rt_name       = "public-rt"
  private_rt_name      = "private-rt"
}

module "ec2" {
  source          = "/home/cloudshell-user/Terraform/ModuleBlock/Resources/EC2"
  vpc_id          = module.vpc.vpc_id
  subnet_id       = module.vpc.public_subnet_id
  ami_id          = "ami-12345678" # Replace with a valid AMI ID
  instance_type   = "t2.micro"
  instance_name   = "web-server"
  sg_name         = "web-server-sg"
  allowed_ssh_cidrs = ["203.0.113.0/24"] # Restrict to your IP range
}