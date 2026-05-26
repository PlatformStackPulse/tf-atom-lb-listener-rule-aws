variable "listener_arn" {
  description = "ARN of the listener"
  type        = string
  validation {
    condition     = length(var.listener_arn) > 0
    error_message = "listener_arn must not be empty."
  }
}

variable "priority" {
  description = "Priority of the rule (1-50000)"
  type        = number
  validation {
    condition     = var.priority >= 1 && var.priority <= 50000
    error_message = "priority must be between 1 and 50000."
  }
}

variable "target_group_arn" {
  description = "ARN of the target group to forward to"
  type        = string
  validation {
    condition     = length(var.target_group_arn) > 0
    error_message = "target_group_arn must not be empty."
  }
}

variable "path_patterns" {
  description = "Path patterns to match (e.g., /api/*)"
  type        = list(string)
  default     = null
}

variable "host_headers" {
  description = "Host headers to match"
  type        = list(string)
  default     = null
}
