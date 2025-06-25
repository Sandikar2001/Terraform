resource "aws_security_group" "ec2_sg" {
  for_each = var.ec2_instances

  name        = "${aws_project}-${each.key}-SG"
  description = "Security group for ${each.key}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ingress
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress
    content {
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = egress.value.description
    }
  }

  tags = {
    Name = "${each.key}-SG"
  }
}

resource "aws_security_group" "alb" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst if inst.attach_to_alb == true
  }

  name   = "${var.aws_project}-${var.env}-${each.key}-alb-sg"
  vpc_id = var.vpc_id
  ingress { 
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
    }
}

resource "aws_security_group_rule" "allow_alb_to_ec2" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst if inst.attach_to_alb == true
  }
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "Allow traffic from ALB for ${each.key}"
  security_group_id        = aws_security_group.ec2_sg[each.key].id
  source_security_group_id = aws_security_group.alb[each.key].id
}


resource "aws_security_group_rule" "allow_alb_egress_to_ec2" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst if inst.attach_to_alb == true
  }
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  description              = "Allow traffic to instance ${each.key}"
  security_group_id        = aws_security_group.alb[each.key].id
  source_security_group_id = aws_security_group.ec2_sg[each.key].id
}