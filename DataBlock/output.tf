output "instance_ip" {
    value = aws_instance.boxer.public_ip
}

output "instance_id" {
    value = aws_instance.boxer.id
}