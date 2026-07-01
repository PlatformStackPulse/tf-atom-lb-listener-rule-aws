# Unit tests for tf-atom-lb-listener-rule-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run a single run: terraform test -test-directory=tests/unit -run creates_when_enabled
#
# NOTE: assertions target plan-KNOWN values only (tf-label pass-throughs,
# resource count, the enabled flag). Computed attributes like the rule id/arn
# are unknown under a mock provider, so we only assert they are null when the
# module is disabled (count = 0 → try(...) yields null).

mock_provider "aws" {}

variables {
  # tf-label context
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # module-specific required inputs
  listener_arn     = "arn:aws:elasticloadbalancing:eu-west-1:123456789012:listener/app/eg-test-alb/50dc6c495c0c9188/f2f7dc8efc522ab2"
  target_group_arn = "arn:aws:elasticloadbalancing:eu-west-1:123456789012:targetgroup/eg-test-tg/73e2d6bc24d8a067"
  priority         = 100
  path_patterns    = ["/api/*"]
}

# ---------------------------------------------------------------------------
# When enabled, the module plans exactly one listener rule and reports enabled.
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "output.enabled should be true when the module is enabled"
  }

  assert {
    condition     = length(aws_lb_listener_rule.this) == 1
    error_message = "exactly one aws_lb_listener_rule should be planned when enabled"
  }

  assert {
    condition     = aws_lb_listener_rule.this[0].priority == 100
    error_message = "the rule priority should pass through the priority input"
  }
}

# ---------------------------------------------------------------------------
# When disabled, no resources are created and id/arn outputs are null.
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "output.enabled should be false when the module is disabled"
  }

  assert {
    condition     = length(aws_lb_listener_rule.this) == 0
    error_message = "no aws_lb_listener_rule should be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "output.id should be null when the module is disabled"
  }

  assert {
    condition     = output.arn == null
    error_message = "output.arn should be null when the module is disabled"
  }
}
