this_ami      = "ami-042e76978adeb8c48"  # Use an appropriate AMI ID for your region
instance_type = "t2.micro"
key_name      = "batmobile"     # Replace with your EC2 key pair name
vpc_id        = "vpc-03276f1b3bce97eec"           # Replace with your VPC ID
subnet_ids    = ["subnet-07d50e514206d0408", "subnet-0cb026ebf3a0bf22e", "subnet-0a7d16e970a6d7b9f", "subnet-0c695957469386d8e"]
domain_name   = "swapnilbdevops.online"            # Replace with your domain name
subdomain     = "student"                   # Subdomain to bind (e.g., 'todo.example.com')

# VPC Variables
vpc_id      = "vpc-03276f1b3bce97eec"
subnet_ids  = ["subnet-07d50e514206d0408", "subnet-0cb026ebf3a0bf22e"]

# EC2 Variables
this_ami                   = "ami-042e76978adeb8c48"
instance_type              = "t2.micro"
key_name                   = "batmobile"
associate_public_ip_address = true
instance_count             = 1
availability_zone          = "us-east-1a"
this_aws_instance_volume_size = 10

# RDS Variables
db_identifier              = "my-rds-instance"
db_engine                  = "mysql"
db_engine_version          = "8.0"
db_instance_class          = "db.t3.micro"
allocated_storage          = 20
db_username                = "admin"
db_password                = "YourSecurePasswordHere"
db_name                    = "studentdb"
skip_final_snapshot        = true
multi_az                   = false
storage_type               = "gp2"
publicly_accessible        = false
final_snapshot_identifier  = "my-rds-instance-final-snapshot"
vpc_security_group_ids     = ["sg-0a1b2c3d4e5f6g7h"]
db_subnet_group_name       = "studentapp-db-subnet"
