terraform {
    backend "s3" {
        bucket = "swapnil008"
        key = "terraform.tfstate"
        dynamodb_table = "cbz"
        region = "ap-northeast-2"
        profile = "swapnil"
        shared_credentials_files = ["/home/swapnil/.aws/credentials"]
    }
}


module "vpc" {
  source = "/home/cloudshell-user/Studentapp_Terraform/Resources/VPC"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr_a = "10.0.1.0/24"
  public_subnet_cidr_b = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  availability_zone_a  = "us-east-1a"
  availability_zone_b  = "us-east-1b"
  vpc_name             = "MyVPC"
  igw_name             = "MyIGW"
  public_subnet_name   = "PublicSubnet"
  private_subnet_name  = "PrivateSubnet"
  public_rt_name       = "PublicRouteTable"
  private_rt_name      = "PrivateRouteTable"
}
