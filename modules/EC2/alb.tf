resource "aws_lb" "main" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst if inst.attach_to_alb == true
  }
  name               = "${var.aws_project}-${var.env}-${each.key}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[each.key].id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "main" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst 
    if inst.attach_to_alb == true
  }
  name     = "${var.aws_project}-${var.env}-${each.key}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Create one Listener for each ALB.
resource "aws_lb_listener" "main" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst if inst.attach_to_alb == true
  }
  load_balancer_arn = aws_lb.main[each.key].arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[each.key].arn
  }
}
