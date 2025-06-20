resource "aws_eip" "eip" {
  for_each = {
    for key, inst in var.ec2_instances : key => inst
    if try(inst.assign_eip, false)
  }

  instance = aws_instance.ec2[each.key].id
  domain   = "vpc"


  tags = {
    Name = "${each.key}-eip"
  }
  depends_on = [aws_instance.ec2]
}
