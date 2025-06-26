resource "aws_db_subnet_group" "rds_db_sng" {
  subnet_ids = var.db_subnets

  tags = {
    Name = "${aws_project}-${env}-rds-sng"
  }
}