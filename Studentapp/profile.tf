provider "aws" {
   profile = "swapnil"
   region  = "ap-northeast-2"
    default_tags {
                tags = {
                    name = "aws"
                }
    }
}