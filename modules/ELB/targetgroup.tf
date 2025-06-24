resource "aws_lb_target_group" "main" {
  name     = "${locals.alb_name}-${locals.port}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

