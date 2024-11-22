provider "aws" {
   profile = "swapnil"
    default_tags {
                tags = {
                    name = "aws"
                }
    }
}

resource "aws_instance" "this_aws_instance" {
    for_each = toset(var.imageid)
    ami = each.value
    #vpc_security_group_ids = ["sg-032e1a4a1685a03be"]
    #key_name = "rahul"
    instance_type = "t3.micro"    
}   

resource "aws_iam_user" "main_user"{
    for_each = toset(var.main_user_name)
    name = each.value
}

variable "main_user_name" {
    type = list(string)
   
    default = ["ubuntu","awslinux","amazonlinux2"]
}

variable "imageid" {
    type = list(string)
    default = ["ami-042e76978adeb8c48","ami-0de20b1c8590e09c5","ami-04cb1684c278156a3"]

}

output "aws_ec2" {
  value = [
    for instance in var.imageid:
        aws_instance.this_aws_instance[instance].public_ip
  ]
}
