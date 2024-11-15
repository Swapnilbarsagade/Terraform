# Security Group to allow HTTP access
resource "aws_security_group" "boxer_sg" {
  name        = "boxer_app_sg"
  description = "Allow HTTP traffic for Static boxer app"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for the boxer app
resource "aws_instance" "boxer_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.boxer_sg.name]
  key_name      = var.key_name

  # User data script to install Nginx and set up the boxer app
  user_data = <<-EOF
    #!/bin/bash
    sudo apt install unzip -y curl
    sudo apt install nginx -y
    curl -O https://www.free-css.com/assets/files/free-css-templates/download/page296/oxer.zip
    sudo unzip oxer.zip
    sudo rm -rf /var/www/html/*
    sudo mv oxer-html/* /var/www/html/
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF

  tags = {
    Name = "boxer"
  }
}

