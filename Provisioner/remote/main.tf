resource "aws_instance" "this_aws_instance" {
  ami = "ami-0f1e61a80c7ab943e"
  vpc_security_group_ids = ["sg-0e4a706367d42c3a8"]
  key_name = "batmobile"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Default user for ec2-user AMIs; replace if needed
      private_key = file("${path.module}/batmobile.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "MyInstance"
  }
}

/*provisioner "remote-exec" {
  script = "path/to/script.sh"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("path/to/batmobile.pem")
    host        = self.public_ip
  }
}*/

 