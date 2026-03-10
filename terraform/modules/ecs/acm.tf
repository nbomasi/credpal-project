resource "aws_acm_certificate" "app" {
  count = var.create_acm_cert ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-cert" })

  lifecycle {
    create_before_destroy = true
  }
}
