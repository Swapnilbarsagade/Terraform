# Security Group to allow HTTP access
resource "aws_security_group" "carvcilla_sg" {
  name        = "carvcilla_app_sg"
  description = "Allow HTTP traffic for Static app"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance for the carvcilla app
resource "aws_instance" "carvcilla_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.carvcilla_sg.name]
  key_name      = var.key_name

  # User data script to install Nginx and set up the ToDo app
  user_data = <<-EOF
    #!/bin/bash
    sudo apt install unzip -y curl
    sudo apt install nginx -y
    curl -O https://www.free-css.com/assets/files/free-css-templates/download/page296/oxer.zip
    curl -O https://www.free-css.com/assets/files/free-css-templates/download/page296/carvcilla.zip
    sudo unzip carvcilla.zip
    sudo rm -rf /var/www/html/*
    sudo mv carvcilla-html/* /var/www/html/
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF

  tags = {
    Name = "carvcilla"
  }
}

# Route 53 Hosted Zone (if you don’t already have it)
data "aws_route53_zone" "selected_zone" {
  name         = var.domain_name
  private_zone = false
}

# Route 53 DNS Record to bind the domain to the EC2 instance's public IP
resource "aws_route53_record" "carvcilla_dns_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [aws_instance.carvcilla_instance.public_ip]
}
