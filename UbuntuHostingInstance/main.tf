resource "aws_instance" "bodygaurd" {
  ami           = "ami-042e76978adeb8c48"
  instance_type = "t2.micro"
  key_name = "batmobile"
  associate_public_ip_address = "true"
}
