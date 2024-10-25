provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami                         = "ami-0ad21ae1d0696ad58" 
  instance_type               = "t2.medium"
  count                       = 2  # Number of instances
  key_name                    = "devopskey" # Create and download key already
  security_groups             = ["DevOps"]  # Existing Security Group
  associate_public_ip_address = true

  root_block_device {
    volume_size = 20  # Storage size in GiB
    volume_type = "gp3"
  }

  tags = {
    Name = "${count.index == 0 ? "monitoring" : "VM"}"
  }
}
