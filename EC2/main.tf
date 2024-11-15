resource "aws_security_group" "this_student_sg" {
  name        = "student-security-group"
  description = "Security group for my StudentApp"
  vpc_id      = var.vpc_id  # replace with your VPC ID

  # Inbound rules
  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Replace with specific IP for better security
  }

  ingress {
    description      = "Allow SSH access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]  # Replace with specific IP for better security
  }

  # Outbound rules
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "student-sg"
  }
}





resource "aws_instance" "web" {
  ami           = var.this_ami
  instance_type = var.instance_type
  key_name      = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  count                       = var.instance_count
  vpc_security_group_ids = [aws_security_group.this_student_sg.id]
  #availability_zone      = var.availability_zone
  root_block_device {
    volume_size = var.this_aws_instance_volume_size
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y

              # Download and install Tomcat
              cd /tmp
              curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz
              tar -xvf apache-tomcat-9.0.97.tar.gz
              sudo mv apache-tomcat-9.0.97 /opt/tomcat

              # Start Tomcat
              sudo bash /opt/tomcat/bin/start.sh
    EOF

  tags = {
    Name = "StudentApp"
  }
}