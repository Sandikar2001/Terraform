variable "aws_project" {
  description = "Name of the project."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod')."
  type        = string
}

variable "rules" {
  description = "A list of rule objects to apply to the Web ACL."
  type = list(object({
    name     = string
    priority = number
    # This structure is specifically for AWS Managed Rule Groups.
    # We can expand this later for custom rules like IP sets or rate-based rules.
    managed_rule_group = object({
      vendor_name = string
      name        = string
    })
  }))
  default = []
}

variable "resource_arns_to_associate" { 
  description = "A list of resource ARNs (e.g., ALBs) to associate this Web ACL with."
  type        = map(string) 
}