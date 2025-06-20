output"vpc_id" {
value = aws_vpc.main.id
}

output "igw_id" {
value = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {
  value = { for k, s in aws_subnet.public-subnets : k => s.id }
}

output "ngw_id" {
   value = aws_nat_gateway.ngw.id
}

output "db_subnet_ids" {
  value = { for k, s in aws_subnet.private-db-subnets : k => s.id }
}

output "app_subnet_ids" {
  value = { for k, s in aws_subnet.private-app-subnets : k => s.id }
}