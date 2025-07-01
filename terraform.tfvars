aws_project = "Terraform"
environment = "Test"
vpc_cidr    = "172.10.0.0/16"
region      = "ap-south-2"

public_subnet_cidr = {
  "1" = {
    cidr = "172.10.1.0/25"
    az   = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.1.128/25"
    az   = "ap-south-2b"
  }
}

db_subnet_cidr = {
  "1" = {
    cidr = "172.10.2.0/25"
    az   = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.2.128/25"
    az   = "ap-south-2b"
  }
}

app_subnet_cidr = {
  "1" = {
    cidr = "172.10.3.0/25"
    az   = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.3.128/25"
    az   = "ap-south-2b"
  }
}

sg_egress = {
  "80" = {
    description = "Allow HTTP"
    port        = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  "443" = {
    description = "Allow HTTPS"
    port        = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

sg_ingress = {
  "22" = {
    description = "Allow SSH from specific IP"
    port        = 22
    protocol    = "tcp"
    cidr_blocks = ["182.71.180.130/32"]
  }
}

ec2_instance_base = {
  "app1" = {
    ami           = "ami-0d7542f8f0105592a"
    instance_type = "t3.micro"
    key_name      = "test2"
    tags          = { terraform = "app1" }
    subnet_group  = "app"
    subnet_key    = "1"
    attach_to_alb = true
    connect_to_rds = true  
  }

  "jump" = {
    ami           = "ami-0d7542f8f0105592a"
    instance_type = "t3.micro"
    key_name      = "test2"
    tags          = { terraform = "jump" }
    subnet_group  = "public"
    subnet_key    = "1"
    assign_eip    = true
    associate_public_ip_address = true
  }
}

alb_instance_name = "web1"


#RDS VAR VALUES
rds_engine = "mysql"
rds_engine_version = "8.0"
rds_multi_az = false
rds_instance_class = "db.m7g.large"
rds_storage = 100
rds_password = "admin123"
rds_user = "admin"
rds_db_name = "testdb"

