
data "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.aws_project}-PVT-RT"
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public-subnets
  subnet_id      = each.value.id
  route_table_id = data.aws_route_table.main.id
  #depends_on = [aws_subnet.public-subnets]
}

resource "aws_route_table_association" "private-app" {
  for_each = aws_subnet.private-app-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-route-table.id
  #depends_on = [aws_subnet.private-db-subnets, aws_subnet.private-app-subnets]
}

resource "aws_route_table_association" "private-db" {
  for_each = aws_subnet.private-db-subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private-route-table.id
  #depends_on = [aws_subnet.public-subnets]
}
