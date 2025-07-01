output "ec2_instance_details" {
  description = "Instance IDs and Private IPs"
  value = {
    for key, instance in aws_instance.ec2 :
    key => {
      id         = instance.id
      private_ip = instance.private_ip
      public_ips = lookup(aws_eip.eip, key, null) != null ? aws_eip.eip[key].public_ip : null
    }
  }
}

output "ec2_public_eips" {
  value = {
    for key, eip in aws_eip.eip : key => eip.public_ip
  }
}

output "instance_ids" {
  value = { for k, inst in aws_instance.ec2 : k => inst.id }
}

output "instance_security_group_ids" {
  value = { for key, sg in aws_security_group.ec2_sg : key => sg.id }
}

output "alb_dns_names" {
  description = "A map of instance names to the DNS names of their associated ALBs."
  value = {
    for key, lb in aws_lb.main : key => lb.dns_name
  }
}



