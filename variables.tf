variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
}

data "aws_ssm_parameter" "app_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

variable "environment" {
  description = "Deployment environment"
  type        = object ({
    name           = string
    network_prefix = string
  })
  default     = {
    name           = "dev"
    network_prefix = "10.0"
  }
}

variable "min_size" {
  default     = 1
  description = "Minimum number of instances in the ASG"
}

variable "max_size" {
  default     = 1
  description = "Maximum number of instances in the ASG"
}