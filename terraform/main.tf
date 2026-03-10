terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "local" {
    path = "terraform.tfstate"
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  single_nat_gateway   = var.single_nat_gateway

  tags = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  public_subnet_ids   = module.vpc.public_subnets

  container_image    = var.container_image
  container_port     = var.container_port
  cpu                = var.ecs_cpu
  memory             = var.ecs_memory

  domain_name         = var.domain_name
  create_acm_cert     = var.domain_name != ""
  enable_https_redirect = var.domain_name != ""
  route53_zone_id     = var.route53_zone_id

  tags = local.common_tags
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
