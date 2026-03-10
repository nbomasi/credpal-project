bucket         = "credpal-terraform-state-staging"
key            = "credpal/staging/terraform.tfstate"
region         = "eu-west-1"
encrypt        = true
dynamodb_table = "credpal-terraform-locks-staging"
