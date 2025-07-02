variable "aws_project" {
  description = "The Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

variable "vpc_cidr" {
  description = "Specify VPC CIDR range"
}

variable "rds_db_name" {
  type = string 
}

variable "public_subnet_cidr" {
  description = "Values for Public Subnet creation"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "app_subnet_cidr" {
  description = "Values for App Subnet creation"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "db_subnet_cidr" {
  description = "Values for Db subnets creation"
  type = map(object({
    cidr = string
    az   = string
  }))
}


variable "sg_ingress" {
  type = map(object(
    {
      description = string
      port        = number
      protocol    = string
      cidr_blocks = list(string)
    }
  ))
}

variable "sg_egress" {
  type = map(object(
    {
      description = string
      port        = number
      protocol    = string
      cidr_blocks = list(string)
    }
  ))
}


variable "ec2_instance_base" {
  type = map(object({
    ami           = string
    instance_type = string
    key_name      = string
    tags          = map(string)
    subnet_group  = string
    subnet_key    = string
    assign_eip    = optional(bool, false)
    attach_to_alb = optional(bool, false)
    connect_to_rds = optional(bool, false)
  }))
}



variable "region" {
  description = "AWS region"
  type        = string
}

variable "alb_instance_name" {
  type = string
}



#RDS VARIABLES

variable "rds_instance_class" { type = string}
variable "rds_engine" { type = string }
variable "rds_engine_version" { type = string }
variable "rds_user" { type = string }
variable "rds_password" { 
  type = string 
  sensitive = true
  }
variable "rds_storage" { type = number }
variable "rds_multi_az" { type = bool }


#WAF VARIABLES

variable "waf_rules" {
  description = "A list of rule objects to apply to the Web ACL."
  type = list(object({
    name     = string
    priority = number
    managed_rule_group = object({
      vendor_name = string
      name        = string
    })
  }))
  default = [] # Providing a default is good practice.
}