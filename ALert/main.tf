provider "aws" {
  region = "ap-northeast-3"
}

resource "aws_instance" "example" {
  ami                         = "ami-0206f4f885421736f" 
  instance_type               = "t2.medium"
  count                       = 2  # Number of instances
  key_name                    = "thunderfirstform" # Create and download key already
  vpc_security_group_ids      = ["sg-0043a62a72db3f571"]  # Existing Security Group
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20  # Storage size in GiB
    volume_type = "gp3"
  }

  tags = {
    Name = "${count.index == 0 ? "monitoring" : "VM"}"
  }
}
