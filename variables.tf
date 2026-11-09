variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t3.nano"
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
