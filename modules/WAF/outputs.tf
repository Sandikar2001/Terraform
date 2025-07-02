output "alb_arns" {
  description = "The ARN of the created WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.arn
}
