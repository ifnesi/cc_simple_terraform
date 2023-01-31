terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.25.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}

data "external" "env_vars" {
  program = ["${path.module}/env_terraform.sh"]
}

provider "aws" {
  region = var.cloud_region
}

provider "confluent" {
  # Environment variables set on ./env_credentials.sh
  #CONFLUENT_CLOUD_API_KEY    = "XXXXX"
  #CONFLUENT_CLOUD_API_SECRET = "XXXXX"
}

provider "shell" {
  interpreter        = ["/bin/sh", "-c"]
  enable_parallelism = false
}
