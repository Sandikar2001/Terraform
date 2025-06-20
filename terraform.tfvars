aws_project = "Terraform"
environment = "Test"
vpc_cidr = "172.10.0.0/16"
region = "ap-south-2"

public_subnet_cidr = {
  "1" = {
    cidr = "172.10.1.0/25"
    az = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.1.128/25"
    az = "ap-south-2b"
  } 
}

db_subnet_cidr = {
  "1" = {
    cidr = "172.10.2.0/25"
    az = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.2.128/25"
    az = "ap-south-2b"
  }
}

app_subnet_cidr = {
  "1" = {
    cidr = "172.10.3.0/25"
    az = "ap-south-2a"
  }
  "2" = {
    cidr = "172.10.3.128/25"
    az = "ap-south-2b"
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
    subnet_group  = "app"    # 👈 Needed!
    subnet_key    = "1"      # 👈 Needed!
  }

  "jump" = {
    ami           = "ami-0d7542f8f0105592a"
    instance_type = "t3.micro"
    key_name      = "test2"
    tags          = { terraform = "jump" }
    subnet_group  = "public"
    subnet_key    = "1"
    assign_eip    = true
  }
}
