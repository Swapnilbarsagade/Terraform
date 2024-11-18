module "vpc" {
  source               = "./modules/vpc"
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
