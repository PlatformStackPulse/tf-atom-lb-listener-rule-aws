output "enabled" {
  description = "Whether the module is enabled"
  value       = local.enabled
}

output "id" {
  description = "ID of the listener rule"
  value       = try(aws_lb_listener_rule.this[0].id, null)
}

output "arn" {
  description = "ARN of the listener rule"
  value       = try(aws_lb_listener_rule.this[0].arn, null)
}
