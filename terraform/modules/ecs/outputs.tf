output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.app.name
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}

output "app_url" {
  value = var.create_acm_cert ? "https://${var.domain_name}" : "http://${aws_lb.main.dns_name}"
}

output "acm_certificate_arn" {
  value     = var.create_acm_cert ? aws_acm_certificate.app[0].arn : null
  sensitive = true
}
