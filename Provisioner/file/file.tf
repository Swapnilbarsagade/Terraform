provider "aws" {
    region =  "ap-northeast-2"
    profile = "swapnil"
}
 resource "aws_instance" "this_aws_instance" {
    ami = "ami-04cb1684c278156a3"
    vpc_security_group_ids = ["sg-0ee8e99c42ea4a2a3"]
    key_name = "swapkey"
    instance_type = "t2.micro"
     
     provisioner "file" {
    source      = "readme.md"
    destination = "/home/ec2-user/readme.md"
      connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("${path.module}/swapkey.pem")
    host     = "${self.public_ip}"
  }
  
  
  }


}