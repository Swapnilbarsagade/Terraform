# Security Group for EC2 Instance (Tomcat Web Server)
resource "aws_security_group" "web_server" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "StudentApp-SG"
  }
}

# EC2 Instance for Web Server (Student App with Tomcat 9)
resource "aws_instance" "web_server_instance" {
  ami                    = var.ubuntu_ami
  instance_type          = var.aws_instance_type
  security_groups        = [aws_security_group.web_server.name]
  key_name               = var.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              
              # Download and install Tomcat 9
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz -P /tmp
              sudo tar -xzvf /tmp/apache-tomcat-9.0.97.tar.gz -C /opt/
              sudo mv /opt/apache-tomcat-9.0.97 /opt/tomcat9
              sudo chmod +x /opt/tomcat9/bin/*.sh
              
              # Start Tomcat
              sudo /opt/tomcat9/bin/startup.sh
              EOF

  tags = {
    Name = "StudentApp"
  }
}
