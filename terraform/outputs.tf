output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.ecs.alb_dns_name
}

output "alb_zone_id" {
  description = "ALB Route53 zone ID"
  value       = module.ecs.alb_zone_id
}

output "app_url" {
  description = "Application URL"
  value       = module.ecs.app_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}
