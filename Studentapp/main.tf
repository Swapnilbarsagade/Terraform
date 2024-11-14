# Security Group for EC2 Instance (Tomcat Web Server)
resource "aws_security_group" "web_server" {
  #vpc_id = aws_vpc.main_vpc.id

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
              sudo apt install openjdk-11-jre-headless -y maven
              sudo apt install mariadb-client -y

              # Clone the repository
              git clone https://github.com/Aamantamboli/Studentapp.git /home/ubuntu/Studentapp
              # Navigate to the project directory and build it
              cd /home/ubuntu/Studentapp
              mvn clean package

              # Download and install Tomcat
              cd /tmp
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz  #Check for new version if doesnt work
              tar -xvf apache-tomcat-9.0.97.tar.gz
              sudo mv apache-tomcat-9.0.97 /opt/tomcat

              # Set JAVA_HOME
              export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
              export CATALINA_HOME=/opt/tomcat

              # Copy the built artifacts to Tomcat's webapps directory
              sudo cp /home/ubuntu/Studentapp/target/*.war /opt/tomcat/webapps/
              sudo cp /home/ubuntu/Studentapp/*.jar /opt/tomcat/lib/

              # Start Tomcat
              sudo bash /opt/tomcat/bin/catalina.sh start
              EOF

  tags = {
    Name = "StudentApp"
  }
}
