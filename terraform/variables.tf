variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "credpal"
}

variable "environment" {
  description = "Environment (e.g. dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway for cost savings"
  type        = bool
  default     = true
}

variable "container_image" {
  description = "Container image URI (e.g. ghcr.io/owner/repo:latest)"
  type        = string
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "ecs_cpu" {
  description = "CPU units for ECS task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "Memory in MB for ECS task"
  type        = number
  default     = 512
}

variable "domain_name" {
  description = "Domain name for SSL certificate. Leave empty for HTTP only."
  type        = string
  default     = ""
}

variable "route53_zone_id" {
  description = "Route53 zone ID for ACM validation. Required when domain_name is set."
  type        = string
  default     = ""
}
