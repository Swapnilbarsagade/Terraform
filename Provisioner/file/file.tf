provider "aws" {
    region =  "ap-northeast-2"
    profile = "swapnil"
}
 resource "aws_instance" "this_aws_instance" {
    ami = "ami-0f1e61a80c7ab943e"
    vpc_security_group_ids = ["sg-012e79c059dc4b579"]
    key_name = "swapkey"
    instance_type = "t2.micro"
     
     provisioner "file" {
    source      = "readme.md"
    destination = "/home/ec2-user/readme.md"
      connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("/home/cloudshell-user/Terraform/Provisioner/file/swapkey.pem")
    host     = "${self.public_ip}"
    }
  
  
    }


 }