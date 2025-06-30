resource "aws_instance" "ec2" {
  for_each = var.ec2_instances

  ami                    = each.value.ami
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  key_name               = each.value.key_name
  associate_public_ip_address = try(each.value.associate_public_ip_address, false)
  vpc_security_group_ids = [aws_security_group.ec2_sg[each.key].id]

  tags = merge(
    {
      Name = "${var.aws_project}-${var.env}-${each.key}"
    },
    each.value.tags
  )
}


