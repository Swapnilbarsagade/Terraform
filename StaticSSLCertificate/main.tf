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
  security_groups = [aws_security_group.boxer_sg.id]
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


# Application Load Balancer for instance

# Security Group for Application Load Balancer
resource "aws_security_group" "boxer_alb_sg" {
  name        = "boxer_alb_sg"
  description = "Allow HTTP and HTTPS traffic for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
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

# Application Load Balancer
resource "aws_lb" "boxer_alb" {
  name               = "boxer-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.boxer_alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection      = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "boxer-alb"
  }
}

# Target Group for ALB
resource "aws_lb_target_group" "boxer_target_group" {
  name     = "boxer-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for ALB (HTTP)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.boxer_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.boxer_target_group.arn
  }
}


# Attach EC2 Instance to Target Group
resource "aws_lb_target_group_attachment" "boxer_tg_attachment" {
  target_group_arn = aws_lb_target_group.boxer_target_group.arn
  target_id        = aws_instance.boxer_instance.id
  port             = 80
}

# Route 53 Hosted Zone (if you don’t already have it)
data "aws_route53_zone" "selected_zone" {
  name         = var.domain_name
  private_zone = false
}



# ACM Certificate for the Domain
resource "aws_acm_certificate" "boxer_certificate" {
  domain_name       = var.subdomain
  validation_method = "DNS"

  tags = {
    Name = "boxer-certificate"
  }
}

# Route 53 DNS Validation Record for ACM
resource "aws_route53_record" "acm_validation_record" {
  for_each = { for d in aws_acm_certificate.boxer_certificate.domain_validation_options : d.domain_name => d }
  name     = each.value.resource_record_name
  type     = each.value.resource_record_type
  zone_id  = data.aws_route53_zone.selected_zone.zone_id
  records  = [each.value.resource_record_value]
  ttl      = 300
}

# Validate the ACM Certificate
resource "aws_acm_certificate_validation" "boxer_certificate_validation" {
  certificate_arn         = aws_acm_certificate.boxer_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation_record : record.fqdn]
}

# HTTPS Listener for ALB
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.boxer_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08" # AWS-recommended SSL policy
  certificate_arn = aws_acm_certificate.boxer_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.boxer_target_group.arn
  }
}

# Update the Route 53 Record to Support HTTPS
resource "aws_route53_record" "boxer_dns_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.subdomain
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.boxer_alb.dns_name]
}

resource "aws_lb_listener" "http_redirect_listener" {
  load_balancer_arn = aws_lb.boxer_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
