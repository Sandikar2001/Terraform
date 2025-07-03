variable "aws_project" {
  type = string
}

variable "env" {
 type = string  
}


variable "ec2_instances" {
  description = "Map of EC2 instance configurations"
  type = map(object({
    ami           = string
    instance_type = string
    subnet_id     = string
    key_name      = string
    tags          = map(string)
    assign_eip    = optional(bool, false)
    attach_to_alb = optional(bool, false)
    connect_to_rds =  optional(bool, false)
  }))
}

variable "sg_ingress" {
type = map(object(
{
description = string
port = number
protocol = string
cidr_blocks = list(string)
}
))
default = {
"80" = {
description = "Port 80"
port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
"443" = {
description = "Port 443"
port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
}

variable "sg_egress" {
type = map(object(
{
description = string
port = number
protocol = string
cidr_blocks = list(string)
}
))
default = {
"80" = {
description = "Port 80"
port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
"443" = {
description = "Port 443"
port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
}
}

variable "vpc_id" {
  type = string
  description = "VPC Id from VPC Module"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "Value from vpc module"
}

variable "source_alb_sg_id" {
  description = "The ID of the ALB Security Group to allow traffic from."
  type        = string
  default     = null
}

variable "alb_target_port" {
  type = number
}




