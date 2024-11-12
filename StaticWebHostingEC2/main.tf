# Security Group to allow HTTP access
resource "aws_security_group" "web_sg" {
  name        = "todo_app_sg"
  description = "Allow HTTP traffic for ToDo app"
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

# EC2 Instance for the ToDo app
resource "aws_instance" "todo_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.web_sg.name]
  key_name      = var.key_name

  # User data script to install Nginx and set up the ToDo app
  user_data = <<-EOF
              #!/bin/bash
              # Update the package repository
              sudo apt update -y
              # Install Nginx
              sudo apt install -y nginx
              # Create a simple HTML ToDo app
              echo "<html>
              <head><title>ToDo App</title></head>
              <body>
              <h1>Simple ToDo App</h1>
              <ul>
                <li>Task 1: Buy Groceries</li>
                <li>Task 2: Complete Assignment</li>
                <li>Task 3: Read Book</li>
              </ul>
              </body>
              </html>" > /var/www/html/index.html
              # Start Nginx service
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "ToDoAppInstance"
  }
}

# Route 53 Hosted Zone (if you don’t already have it)
data "aws_route53_zone" "selected_zone" {
  name         = var.domain_name
  private_zone = false
}

# Route 53 DNS Record to bind the domain to the EC2 instance's public IP
resource "aws_route53_record" "todo_dns_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.subdomain
  type    = "A"
  ttl     = 300
  records = [aws_instance.todo_instance.public_ip]
}
