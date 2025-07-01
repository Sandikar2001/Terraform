output "ec2_instance_details" {
  value = module.ec2.ec2_instance_details
}

output "DEBUG_final_filtered_map" {
  description = "Shows the content of the map used by the for_each. Should NOT be empty."
  value       = local.instances_requiring_db_access
}

output "DEBUG_source_data_map" {
  description = "Shows the full processed map BEFORE filtering. Check here for the flag."
  value       = local.processed_instances
}
