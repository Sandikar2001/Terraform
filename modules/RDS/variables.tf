variable "aws_project" { type = string }

variable "env" { type = string }

variable "storage" { type = number}

variable "engine" { type = string}

variable "engine_version" { type = string }

variable "instance_class" { type = string}

variable "username" { type = string }

variable "password" { 
    type = string
    sensitive = true
}

variable "multi_az" {
  type = bool
}

locals {
  rds_name = "${aws_project}-${env}-${db_name}"
}

variable "db_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}