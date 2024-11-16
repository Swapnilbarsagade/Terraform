# RDS Variables
db_identifier              = "my-rds-instance"
db_engine                  = "mysql"
db_engine_version          = "8.0"
db_instance_class          = "db.t3.micro"
allocated_storage          = 20
db_username                = "admin"
db_password                = "admin123"
db_name                    = "studentdb"
skip_final_snapshot        = true
multi_az                   = false
storage_type               = "gp2"
publicly_accessible        = false
final_snapshot_identifier  = "my-rds-instance-final-snapshot"
subnet_ids                 = ["subnet-07d50e514206d0408", "subnet-0cb026ebf3a0bf22e", "subnet-0a7d16e970a6d7b9f", "subnet-0c695957469386d8e"]
vpc_id                     = "vpc-03276f1b3bce97eec"