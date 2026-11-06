data "aws_ssm_parameter" "app_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami           = data.aws_ssm_parameter.app_ami.value
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }
}
