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
              # Copy the student.war file to the Tomcat webapps directory as ROOT.war
              #cp /tmp/aws/tomcat9sstudent/student.war /opt/tomcat/webapps/ROOT.war


              # Start Tomcat using catalina.sh
              /opt/tomcat/bin/catalina.sh stop
              /opt/tomcat/bin/catalina.sh start

              EOF

  tags = {
    Name = "StudentApp"
  }
}

resource "aws_lb" "student_alb" {
  name               = "student-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this_student_sg.id]
  subnets            = var.subnet_ids  # Replace with your subnet IDs

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "student-app-alb"
  }
}

resource "aws_lb_target_group" "student_target_group" {
  name     = "student-app-target-group"
  port     = 8080  # Tomcat runs on port 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id  # Replace with your VPC ID

  health_check {
    path                = "/"
    port                = "8080"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "student-app-target-group"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.student_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.student_target_group.arn
  }
}

resource "aws_lb_target_group_attachment" "student_app_attachment" {
  target_group_arn = aws_lb_target_group.student_target_group.arn
  target_id        = aws_instance.web.id
  port             = 8080
}
