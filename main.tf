resource "aws_lb_listener_rule" "this" {
  count = module.this.enabled ? 1 : 0

  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  dynamic "condition" {
    for_each = var.path_patterns != null ? [1] : []
    content {
      path_pattern {
        values = var.path_patterns
      }
    }
  }

  dynamic "condition" {
    for_each = var.host_headers != null ? [1] : []
    content {
      host_header {
        values = var.host_headers
      }
    }
  }

  tags = module.this.tags
}
