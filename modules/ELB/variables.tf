variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "target_instance_ids" { 
    type = list(string)
    default = [] 
    }


variable "destination_sg_ids" {
  description = "A list of security group IDs the ALB can send traffic to."
  type        = list(string)
  default     = []
}

variable "aws_project" {
    type = string
}

variable "primary_instance_name" {
  type = string
}

locals {
  port = aws_lb_target_group.main.port
}

locals {
  alb_name = aws_lb.alb.name
}

