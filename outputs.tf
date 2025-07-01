output "ec2_instance_details" {
  value = module.ec2.ec2_instance_details
}

output "LB_DNS_NAME" {
  description = "The public DNS names for all Application Load Balancers."
  value       = module.ec2.alb_dns_names
}
