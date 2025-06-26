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

output "DEBUG_EC2_INSTANCES_VARIABLE" {
  description = "DEBUG: Shows the value of the ec2_instances variable as seen by the module."
  value       = var.ec2_instances
}
