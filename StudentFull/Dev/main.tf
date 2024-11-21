terraform {
    backend "s3" {
        bucket = "swapnil008"
        key = "terraform.tfstate"
        //dynamodb_table = "cbz"
        region = "ap-northeast-2"
        profile = "swapnil"
        shared_credentials_files = ["/home/swapnil/.aws/credentials"]
    }
}


module "vpc" {
  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/VPC"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr_a = "10.0.1.0/24"
  public_subnet_cidr_b = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  availability_zone_a  = "ap-northeast-2a"
  availability_zone_b  = "ap-northeast-2b"
  vpc_name             = "MyVPC"
  igw_name             = "MyIGW"
  public_subnet_name   = "PublicSubnet"
  private_subnet_name  = "PrivateSubnet"
  public_rt_name       = "PublicRouteTable"
  private_rt_name      = "PrivateRouteTable"
}


module "ec2" {
  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/EC2"

  project_name     = "my-project"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  ubuntu_ami_id    = "ami-042e76978adeb8c48" #  AMI ID for Ubuntu
  instance_type    = "t2.micro"
}

//module "route53" {
//  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/Route53"
//
//  domain_name   = "swapnilbdevops.online"
//  alb_dns_name  = module.ec2.alb_dns_name
//  alb_zone_id   = module.ec2.alb_zone_id
//}