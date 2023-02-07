terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.51.0"
    }
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.25.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.8.0"
    }
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.2.3"
    }
  }
}


provider "aws" {
  region = var.cloud_region
}

provider "confluent" {
  # Environment variables to be set on ./env_credentials.sh (see README.md)
  #CONFLUENT_CLOUD_API_KEY    = "XXXXX"
  #CONFLUENT_CLOUD_API_SECRET = "XXXXX"
}

provider "mongodbatlas" {
  # Environment variables to be set on ./env_credentials.sh (see README.md)
  #public_key          = "XXXXX"
  #private_key         = "XXXXX"
}

provider "shell" {
  interpreter        = ["/bin/sh", "-c"]
  enable_parallelism = false
}

data "external" "env_vars" {
  program = ["${path.module}/env_terraform.sh"]
}
