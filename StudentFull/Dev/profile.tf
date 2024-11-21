provider "aws" {
   profile = "swapnil"
   region  = "ap-northeast-2"
   shared_credentials_files = ["/home/cloudshell-user/.aws/credentials"]
    default_tags {
                tags = {
                    name = "aws"
                }
    }
}