resource "aws_db_instance" "rds-db" {
  allocated_storage    = var.storage
  db_name              = "${var.aws_project}-${var.env}-rds"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  username             = var.username
  password             = var.password
  publicly_accessible  = false
  skip_final_snapshot  = true
  multi_az             = var.multi_az
  db_subnet_group_name = aws_db_subnet_group.rds_db_sng.name
  storage_encrypted    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}
