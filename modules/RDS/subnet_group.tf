resource "aws_db_subnet_group" "rds_db_sng" {
  subnet_ids = var.db_subnets

  tags = {
    Name = "${var.aws_project}-${var.env}-rds-sng"
  }
}
