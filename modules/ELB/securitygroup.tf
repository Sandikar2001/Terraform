resource "aws_security_group" "alb" {
  name   = "${locals.alb_name}-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 80 
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "tcp"
    security_groups = var.destination_sg_ids 
  }
}

