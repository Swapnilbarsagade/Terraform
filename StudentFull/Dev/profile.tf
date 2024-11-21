provider "aws" {
   profile = "swapnil"
   region  = "ap-northeast-2"
   shared_credentials_files = ["/home/swapnil/.aws/credentials"]
    default_tags {
                tags = {
                    name = "aws"
                }
    }
}