data "aws_ami" "this_boxer_ami" {
    name_regex       = "boxer_ami"
      filter {
    name   = "name"
    values = ["boxer_ami"]
    }

}

data "aws_security_group" "default" {
  name = "default"  #var.vpc_security_group_ids[2]
}