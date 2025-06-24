resource "aws_lb" "main" {
  name               = "${aws_project}-${primary_instance_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = aws_security_group.alb-sg.id
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group_attachment" "main" {
  for_each         = toset(var.target_instance_ids)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.value
}