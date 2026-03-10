bucket         = "credpal-terraform-state-prod"
key            = "credpal/prod/terraform.tfstate"
region         = "eu-west-3"
encrypt        = true
dynamodb_table = "credpal-terraform-locks-prod"
