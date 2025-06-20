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