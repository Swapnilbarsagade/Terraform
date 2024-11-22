terraform {
    backend "s3" {
        bucket = "swapnil008"
        key = "terraform.tfstate"
        //dynamodb_table = "cbz"
        region = "ap-northeast-2"
        profile = "swapnil"
        shared_credentials_files = ["/home/cloudshell-user/.aws/credentials"]
    }
}


module "vpc" {
  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/VPC"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr_a = "10.0.1.0/24"
  public_subnet_cidr_b = "10.0.2.0/24"
  private_subnet_cidr_a = "10.0.3.0/24"
  private_subnet_cidr_b = "10.0.4.0/24"
  availability_zone_a  = "ap-northeast-2a"
  availability_zone_b  = "ap-northeast-2b"
  vpc_name             = "MyVPC"
  igw_name             = "MyIGW"
  public_subnet_name   = "PublicSubnet"
  private_subnet_name  = "PrivateSubnet"
  public_rt_name       = "PublicRouteTable"
  private_rt_name      = "PrivateRouteTable"
}


module "ec2" {
  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/EC2"

  project_name     = "studentapp"
  vpc_id           = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnets
  ubuntu_ami_id    = "ami-042e76978adeb8c48" #  AMI ID for Ubuntu
  instance_type    = "t2.micro"
  certificate_arn   = module.route53.certificate_arn

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y openjdk-11-jdk mariadb-client

              # Set JAVA_HOME
              echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> /etc/profile.d/java.sh
              source /etc/profile.d/java.sh

              # Install Tomcat
              wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.97/bin/apache-tomcat-9.0.97.tar.gz
              tar xzvf apache-tomcat-9.0.97.tar.gz -C /opt
              ln -s /opt/apache-tomcat-9.0.97 /opt/tomcat
              chown -R root:root /opt/tomcat

              # Clone and deploy application
              git clone https://github.com/Swapnilbarsagade/AWS.git /tmp/aws
              cp /tmp/aws/tomcat9sstudent/student.war /opt/tomcat/webapps/
              cp /tmp/aws/tomcat9sstudent/mysql-connector.jar /opt/tomcat/lib/

              # Configure database connection
              cat <<EOL > /opt/tomcat/conf/context.xml
              <Context>
                  <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
                            maxTotal="100" maxIdle="30" maxWaitMillis="10000"
                            username="${module.rds.db_username}" password="${module.rds.db_password}" driverClassName="com.mysql.jdbc.Driver"
                            url="jdbc:mysql://${module.rds.db_endpoint}:${module.rds.db_port}/${module.rds.db_name}"/>
              </Context>
              EOL

              /opt/tomcat/bin/startup.sh
              EOF
}

module "rds" {
  source              = "/home/cloudshell-user/Terraform/StudentFull/Resources/RDS"
  project_name        = "studentdb"
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  allowed_cidr_blocks = ["10.0.0.0/16"] # Adjust as per your requirements
  db_name             = "studentappdb"
  db_username         = "admin"
  db_password         = "admin123"
  allocated_storage   = 20
  engine_version      = "10.6"
  instance_class      = "db.t3.micro"
  skip_final_snapshot = true
  deletion_protection = false
}

module "route53" {
  source = "/home/cloudshell-user/Terraform/StudentFull/Resources/Route53"

  domain_name   = "swapnilbdevops.online"
  project_name    = var.project_name
  route53_zone_id = var.route53_zone_id
  alb_dns_name    = module.ec2.alb_dns_name
  alb_zone_id     = module.ec2.alb_zone_id
}