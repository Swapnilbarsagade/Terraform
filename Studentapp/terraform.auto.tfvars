this_ami      = "ami-042e76978adeb8c48"  # Use an appropriate AMI ID for your region
instance_type = "t2.micro"
key_name      = "batmobile"     # Replace with your EC2 key pair name
vpc_id        = "vpc-03276f1b3bce97eec"           # Replace with your VPC ID
subnet_ids    = ["subnet-0123456789abcdef", "subnet-abcdef0123456789"]
domain_name   = "swapnilbdevops.online"            # Replace with your domain name
subdomain     = "student"                   # Subdomain to bind (e.g., 'todo.example.com')