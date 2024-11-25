provider "aws" {
    region =  "ap-northeast-2"
    access_key = ""
    secret_key = ""
    profile = "swapnil"
}
 resource "aws_instance" "this_aws_instance" {
    ami = "ami-040c33c6a51fd5d96"
    vpc_security_group_ids = ["sg-012e79c059dc4b579"]
    key_name = "swapkey"
    instance_type = "t2.micro"
     
     provisioner "file" {
    source      = "readme.md"
    destination = "/home/ubuntu/readme.md"
      connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("${path.module}/id_rsa.pem")
    host     = "${self.public_ip}"
  }
  
  
  }


}