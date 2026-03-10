# CredPal DevOps Assessment

Production-ready Node.js application with full CI/CD and infrastructure automation.

## Application

- **Endpoints**: `GET /health`, `GET /status`, `POST /process`
- **Port**: 3000

## Run Locally

### Prerequisites

- Node.js 20+
- Docker & Docker Compose (optional, for containerized run)

### Option 1: Node.js

```bash
cd app
npm install
npm start
```

App runs at http://localhost:3000

### Option 2: Docker Compose

```bash
cd app
cp .env.example .env
# Edit .env with POSTGRES_USER, POSTGRES_PASSWORD, POSTGRES_DB
docker compose up -d
```

App runs at http://localhost:3000

## Access the App

- **Local**: http://localhost:3000
- **Deployed**: Use `terraform output app_url` after deployment

## Deploy

### Prerequisites

- AWS CLI configured
- Terraform 1.5+
- S3 bucket and DynamoDB table for state (see `terraform/DEPLOYMENT.md`)

### Deploy Infrastructure

```bash
cd terraform
terraform init -backend-config=environments/prod/backend.hcl
terraform plan -var-file=environments/prod/terraform.tfvars
terraform apply -var-file=environments/prod/terraform.tfvars
```

Update `container_image` in `terraform/environments/prod/terraform.tfvars` with your GHCR image before apply. For CI/CD: make the GHCR package **public** (Package settings → Change visibility) so ECS can pull the image.

## Key Decisions

### Security

- **Secrets**: No secrets in code. `.env` for local, AWS Secrets Manager for production (when integrated). `terraform.tfvars` excluded from git.
- **Container**: Non-root user (`appuser`), minimal Alpine base, HEALTHCHECK in Dockerfile.
- **HTTPS**: ACM certificate with Route53 validation when domain is configured.

### CI/CD

- **Triggers**: Push and PR to `main`. Build and push only on push to `main`.
- **Stages**: Test → Build (sequential, build runs only after test passes).
- **Registry**: GitHub Container Registry (GHCR). No extra secrets; uses `GITHUB_TOKEN`.
- **Production**: `environment: production` for manual approval before image push.

### Infrastructure

- **VPC**: Public `terraform-aws-modules/vpc/aws` module. Private and public subnets, NAT gateway.
- **Compute**: ECS Fargate (no EC2 management). Rolling deployments via ECS deployment controller.
- **Load balancer**: ALB with health checks on `/health`.
- **State**: S3 + DynamoDB per environment (dev, staging, prod). Local backend for development.

### Deployment Strategy (Part 4)

- **Zero-downtime**: ECS rolling deployment with `minimum_healthy_percent = 100` and `maximum_percent = 200`. New tasks start before old ones drain. Circuit breaker with rollback on failure.
- **Manual approval**: Build and Deploy jobs use `environment: production`. Configure required reviewers in GitHub repo Settings → Environments → production.
- **CI/CD deploy**: After build, the deploy job runs `terraform apply` to update ECS with the new image. Requires GitHub secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`. Optional: `AWS_REGION` variable (default: eu-west-3).
