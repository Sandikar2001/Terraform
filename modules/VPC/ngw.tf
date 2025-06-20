resource "aws_eip" "nat-eip" {
  domain = "vpc"

  tags = {
    Name = "${var.aws_project}-nat-eip"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnets["1"].id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "${var.aws_project}-NGW"
  }
}