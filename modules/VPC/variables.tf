variable "aws_project" {
type = string 
}

variable "vpc_cidr" {
type = string  
}

variable "env" {
type = string
}

variable "public_subnet_cidr" {
  type = map(object({
    cidr =  string
    az = string
  }))
}

variable "app_subnet_cidr" {
  type = map(object({
    cidr =  string
    az = string
  }))
}

variable "db_subnet_cidr" {
  type = map(object({
    cidr =  string
    az = string
  }))
}

