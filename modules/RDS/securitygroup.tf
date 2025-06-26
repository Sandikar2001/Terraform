resource "aws_security_group" "rds" {
  name        = "${var.aws_project}-${var.env}-rds-sg"
  description = "Allow traffic from application servers"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${locals.rds_name}-SG-01"
  }
}