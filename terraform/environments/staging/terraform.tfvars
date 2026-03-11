aws_region   = "eu-west-1"
project_name = "credpal"
environment  = "staging"
vpc_cidr     = "10.1.0.0/16"

availability_zones   = ["eu-west-1a", "eu-west-1b"]
private_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
public_subnet_cidrs  = ["10.1.101.0/24", "10.1.102.0/24"]

container_image = "ghcr.io/YOUR_USERNAME/credpal-project:latest"

ecs_cpu    = 256
ecs_memory = 512
