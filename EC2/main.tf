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
    description      = "Allow tomcat port access"
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
  #count                       = var.instance_count
  vpc_security_group_ids = [aws_security_group.this_student_sg.id]
  #availability_zone      = var.availability_zone
  root_block_device {
    volume_size = var.this_aws_instance_volume_size
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              apt-get update -y

              # Install Java (required for Tomcat)
              apt-get install -y openjdk-11-jdk

              # Set JAVA_HOME
              echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/profile.d/java.sh
              source /etc/profile.d/java.sh

              # Download and install Tomcat 9.0.97
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz
              tar xzvf apache-tomcat-9.0.97.tar.gz -C /opt

              # Create a symbolic link to make Tomcat accessible
              ln -s /opt/apache-tomcat-9.0.97 /opt/tomcat

              # Set permissions
              chown -R root:root /opt/tomcat

              # Clone the Git repository that contains the student.war file
              git clone https://github.com/Swapnilbarsagade/AWS.git /tmp/aws

              # Copy the student.war file to the Tomcat webapps directory
              cp /tmp/aws/tomcat9sstudent/student.war /opt/tomcat/webapps/

              # Start Tomcat using catalina.sh
              /opt/tomcat/bin/catalina.sh stop
              /opt/tomcat/bin/catalina.sh start

              EOF

  tags = {
    Name = "StudentApp"
  }
}

# Route 53 Hosted Zone (if you don’t already have it)
data "aws_route53_zone" "selected_zone" {
  name         = var.domain_name
  private_zone = false
}

# Route 53 DNS Record to bind the domain to the EC2 instance's public IP
resource "aws_route53_record" "student_dns_record" {
  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = var.subdomain
   type    = "A"
  alias {
    name                   = aws_lb.student_app_alb.dns_name
    zone_id                = aws_lb.student_app_alb.zone_id
    evaluate_target_health = true
  }
}

# SSL certificate ACM

resource "aws_acm_certificate" "student_certificate" {
  domain_name = var.domain_name  # Replace with your domain
  validation_method = "DNS"

  tags = {
    Name = "StudentApp-SSL-Certificate"
  }
}

# Add DNS validation (if you use Route 53 for your domain)
resource "aws_route53_record" "student_certificate_validation" {
  for_each = {
    for dvo in aws_acm_certificate.student_certificate.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = data.aws_route53_zone.selected_zone.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}



#Application load balancer

resource "aws_lb" "student_app_alb" {
  name               = "student-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this_student_sg.id]
  subnets            = var.subnet_ids  # Replace with your subnet IDs

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  idle_timeout = 60

  tags = {
    Name = "StudentApp-ALB"
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.student_app_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn = aws_acm_certificate.student_certificate.arn


  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "HTTPS listener"
    }
  }
}

resource "aws_lb_target_group" "https_target_group" {
  name     = "student-app-https-target-group"
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

resource "aws_lb_listener_rule" "https_listener_rule" {
  listener_arn = aws_lb_listener.https_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https_target_group.arn
  }

  condition {
    host_header {
      values = [var.domain_name]  # Use your domain name here
    }
  }
}
