provider "aws" {
    region = "ap-northeast-2"
     profile = "swapnil"
}     


resource "aws_instance" "this_aws_instance" {
    ami = "ami-040c33c6a51fd5d96"
    vpc_security_group_ids = ["sg-0e4a706367d42c3a8"]
    key_name = "batmobile"
    instance_type = "t2.micro"
     
     provisioner "file" {
    source      = "readme.md"
    destination = "/home/ubuntu/readme.md"   # ubuntu  ami
     connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("${path.module}/batmobile.pem") # navidlai privateip
    host     = "${self.public_ip}"
  }
  }
}  