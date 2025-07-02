resource "aws_wafv2_web_acl" "main" {
  name        = "${var.aws_project}-${var.environment}-web-acl"
  scope       = "REGIONAL" 
  
  default_action {
    allow {}
  }

  # This dynamic block iterates over your list of rules and creates them.
  dynamic "rule" {
    for_each = var.rules

    content {
      name     = rule.value.name
      priority = rule.value.priority
      
      override_action {
        none {} 
      }
      
      statement {
        managed_rule_group_statement {
          vendor_name = rule.value.managed_rule_group.vendor_name
          name        = rule.value.managed_rule_group.name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.aws_project}-${var.environment}-web-acl"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.aws_project}-${var.environment}-web-acl"
  }
}

resource "aws_wafv2_web_acl_association" "main" {
  # Change from count to for_each to loop over the list of ARNs
  for_each = toset(var.resource_arns_to_associate)

  resource_arn = each.value # 'each.value' will be one ARN from the list
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

