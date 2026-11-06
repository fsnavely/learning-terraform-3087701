data "aws_ssm_parameter" "app_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

module "web_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.environment.name
  cidr = "${var.environment.network_prefix}.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["${var.environment.network_prefix}.1.0/24", "1${var.environment.network_prefix}.2.0/24", "${var.environment.network_prefix}.3.0/24"]
  public_subnets  = ["${var.environment.network_prefix}.101.0/24", "${var.environment.network_prefix}.102.0/24", "${var.environment.network_prefix}.103.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.environment.name
  }
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow http and https in. Allow everything out."

  vpc_id = module.web_vpc.vpc_id
}

resource "aws_security_group_rule" "web_http_in" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_https_in" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "web_everything_out" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.web.id
}

module "web_alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "web-alb"
  vpc_id  = module.web_vpc.vpc_id
  subnets = module.web_vpc.public_subnets

  security_groups = [aws_security_group.web.id]

  listeners = {
    web-http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_arn = aws_lb_target_group.web.arn
      }
    }
  }

  tags = {
    Environment = var.environment.name
  }
}

resource "aws_lb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.web_vpc.vpc_id
}

module "web_autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.3.2"

  name = "web"

  min_size = var.min_size
  max_size = var.max_size

  vpc_zone_identifier = module.web_vpc.public_subnets

  launch_template_name = "web"
  security_groups      = [resource.aws_security_group.web.id]
  instance_type        = var.instance_type
  image_id             = data.aws_ssm_parameter.app_ami.value

  traffic_source_attachments = {
    web-alb = {
      traffic_source_identifier = aws_lb_target_group.web.arn
    }
  }
}

