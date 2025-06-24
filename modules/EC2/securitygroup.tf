resource "aws_security_group" "ec2_sg" {
  for_each = var.ec2_instances

  name        = "${each.key}-SG"
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

  # Ingress rule from ALB only if attach_to_alb = true
  dynamic "ingress" {
    for_each = each.value.attach_to_alb == true ? [1] : []
    content {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [var.source_alb_sg_id]
      description     = "Allow traffic from ALB"
    }
  }

  # Egress rules
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
