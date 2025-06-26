resource "aws_security_group" "rds" {
  name        = "${var.aws_project}-{var.env}-rds-SG-01"
  description = "Allow traffic from application servers"
  vpc_id      = var.vpc_id
}
