# Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for my StudentApp"
  vpc_id      = var.vpc_id

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


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

# EC2 Instance
resource "aws_instance" "ubuntu_instance" {
  ami           = var.ubuntu_ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name = "${var.project_name}-ubuntu-instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              # Update the system
              apt-get update -y

              # Install Java (required for Tomcat)
              apt-get install -y openjdk-11-jdk

              # Install MySQL client
              apt-get install -y mariadb-client

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

              # Copy the student.war file to the Tomcat webapps directory and mysql-connector.jar to lib directory
              cp /tmp/aws/tomcat9sstudent/student.war /opt/tomcat/webapps/
              cp /tmp/aws/tomcat9sstudent/mysql-connector.jar /opt/tomcat/lib/

               # Configure the database connection
              cat <<EOL > /opt/tomcat/conf/context.xml
              <Context>
                  <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
                            maxTotal="100" maxIdle="30" maxWaitMillis="10000"
                            username="${var.db_username}" password="${var.db_password}" driverClassName="com.mysql.jdbc.Driver"
                            url="jdbc:mysql://${aws_db_instance.mariadb.endpoint}/${var.db_name}"/>
              </Context>
              EOL

              # Start Tomcat using catalina.sh
              /opt/tomcat/bin/catalina.sh stop
              /opt/tomcat/bin/catalina.sh start

              EOF

}

# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_sg.id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.project_name}-alb"
  }
}

# Target Group
resource "aws_lb_target_group" "tg" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }
}

# ALB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Attach Instance to Target Group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.ubuntu_instance.id
  port             = 80
}
