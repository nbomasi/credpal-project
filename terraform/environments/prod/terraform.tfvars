aws_region   = "eu-west-3"
project_name = "credpal"
environment  = "prod"
vpc_cidr     = "10.2.0.0/16"

availability_zones   = ["eu-west-3a", "eu-west-3b"]
private_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
public_subnet_cidrs  = ["10.2.101.0/24", "10.2.102.0/24"]

container_image = "ghcr.io/nbomasi/credpal-project:latest"

ecs_cpu    = 512
ecs_memory = 1024

domain_name     = "credpal.infra.dareyio.com"
route53_zone_id = "Z0614176ONBAJSW0BH94"
