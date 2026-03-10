# Terraform Deployment Guide

## Environments

Three environments are configured: **dev**, **staging**, and **prod**. Each has its own:

- S3 bucket for Terraform state
- DynamoDB table for state locking
- Variable set (`terraform.tfvars`)

## Prerequisites

### 1. Create S3 Buckets and DynamoDB Tables

Before first `terraform init`, create the backend resources for each environment:

| Environment | S3 Bucket | DynamoDB Table |
|-------------|-----------|----------------|
| dev | credpal-terraform-state-dev | credpal-terraform-locks-dev |
| staging | credpal-terraform-state-staging | credpal-terraform-locks-staging |
| prod | credpal-terraform-state-prod | credpal-terraform-locks-prod |

**S3 bucket:**
- Enable versioning
- Enable server-side encryption (SSE-S3 or SSE-KMS)
- Block public access

**DynamoDB table:**
- Partition key: `LockID` (String)

### 2. Update Variables

Edit `envs/<env>/terraform.tfvars` for each environment:
- `container_image` – your GHCR image URI
- `availability_zones` – AZs for your region
- For HTTPS: `domain_name` and `route53_zone_id`

## Deployment Commands

### Dev

```bash
cd terraform
terraform init -backend-config=envs/dev/backend.hcl
terraform plan -var-file=envs/dev/terraform.tfvars
terraform apply -var-file=envs/dev/terraform.tfvars
```

### Staging

```bash
terraform init -backend-config=envs/staging/backend.hcl
terraform plan -var-file=envs/staging/terraform.tfvars
terraform apply -var-file=envs/staging/terraform.tfvars
```

### Prod

```bash
terraform init -backend-config=envs/prod/backend.hcl
terraform plan -var-file=envs/prod/terraform.tfvars
terraform apply -var-file=envs/prod/terraform.tfvars
```

## Switching Environments

When changing environments, reinitialize the backend:

```bash
terraform init -reconfigure -backend-config=envs/prod/backend.hcl
```

## CI/CD Deployment

The GitHub Actions workflow deploys via Terraform after a successful build. Required setup:

1. **GitHub Secrets** (Settings → Secrets → Actions):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

2. **GitHub Variable** (optional): `AWS_REGION` (default: eu-west-3)

3. **S3 Backend**: The state bucket and DynamoDB table must exist before the first deploy.

## Environment Differences

| Setting | dev | staging | prod |
|---------|-----|---------|------|
| VPC CIDR | 10.0.0.0/16 | 10.1.0.0/16 | 10.2.0.0/16 |
| Subnets | 10.0.x.0/24 | 10.1.x.0/24 | 10.2.x.0/24 |
| ECS CPU | 256 | 256 | 512 |
| ECS Memory | 512 MB | 512 MB | 1024 MB |
