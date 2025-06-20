resource "aws_subnet" "public-subnets" {
  for_each = var.public_subnet_cidr

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.aws_project}-${var.env}-PUB-SUB-${each.key}"
  }
}

resource "aws_subnet" "private-app-subnets" {
  for_each = var.app_subnet_cidr

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.aws_project}-${var.env}-APP-SUB-${each.key}"
  }
}

resource "aws_subnet" "private-db-subnets" {
  for_each = var.db_subnet_cidr

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "${var.aws_project}-${var.env}-DB-SUB-${each.key}"
  }
}
