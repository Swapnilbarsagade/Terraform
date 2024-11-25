
provider "aws" {
   region = "ap-northeast-2"
   profile = "swapnil"
    default_tags {
                tags = {
                    name = "aws"
                }
    }
}

terraform {

required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.66.1"
    }
  }

backend "s3" {
	bucket = "swapnil008" 
	key = "terraform.tfstate"
	region = "ap-northeast-2"
  profile = "swapnil"
}
}
