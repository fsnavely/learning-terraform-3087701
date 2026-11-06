output "instance_ami" {
  value = nonsensitive(aws_instance.web.ami)
}

output "instance_arn" {
  value = aws_instance.web.arn
}
