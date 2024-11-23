
provider "aws" {
    region =  "ap-northeast-2"
    profile = "swapnil"
}
 resource "aws_instance" "this_aws_instance" {
    ami = "ami-04cb1684c278156a3"
    vpc_security_group_ids = ["sg-0ee8e99c42ea4a2a3"]
    key_name = "batmobile"
    instance_type = "t2.micro"
     
     provisioner "file" {
    source      = "readme.md"
    destination = "/home/ec2-user/readme.md"
      connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("${path.module}/id_rsa")
    host     = "${self.public_ip}"
  }
  
  
  }
   provisioner "local-exec" {
    command = "echo ${self.private_ip} >> /tmp/private_ips.txt "
  }
    provisioner "local-exec" {
    working_dir = "/tmp/"
    command = "echo ${self.private_ip} >> workingdir_private_ips.txt "
  }


}
  
  
  
  
 