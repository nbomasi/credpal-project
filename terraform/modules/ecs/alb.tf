resource "aws_lb" "main" {
  name               = "${var.project_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-alb" })
}

resource "aws_lb_target_group" "app" {
  name        = "${var.project_name}-${var.environment}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
  }

  deregistration_delay = 30

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-tg" })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port             = "80"
  protocol         = "HTTP"

  default_action {
    type = var.enable_https_redirect ? "redirect" : "forward"
    dynamic "redirect" {
      for_each = var.enable_https_redirect ? [1] : []
      content {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    target_group_arn = var.enable_https_redirect ? null : aws_lb_target_group.app.arn
  }
}

resource "aws_acm_certificate_validation" "app" {
  count = var.create_acm_cert && var.route53_zone_id != "" ? 1 : 0

  certificate_arn         = aws_acm_certificate.app[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "cert_validation" {
  for_each = var.create_acm_cert && var.route53_zone_id != "" ? {
    for dvo in aws_acm_certificate.app[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

resource "aws_lb_listener" "https" {
  count = var.create_acm_cert && var.route53_zone_id != "" ? 1 : 0

  load_balancer_arn = aws_lb.main.arn
  port             = "443"
  protocol         = "HTTPS"
  ssl_policy       = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn  = aws_acm_certificate_validation.app[0].certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

data "aws_route53_zone" "selected" {
  count   = var.create_acm_cert && var.route53_zone_id != "" ? 1 : 0
  zone_id = var.route53_zone_id
}

resource "aws_route53_record" "alias" {
  count = var.create_acm_cert && var.route53_zone_id != "" ? 1 : 0

  zone_id = var.route53_zone_id
  name    = trimsuffix(var.domain_name, ".${data.aws_route53_zone.selected[0].name}")
  type    = "A"

  alias {
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
    evaluate_target_health = true
  }
}
