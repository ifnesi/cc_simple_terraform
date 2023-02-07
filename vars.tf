locals {
  description = "Resource created using terraform"
}

# --------------------------------------------------------
# This 'random_id_4' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
  byte_length = 4
}


# --------------------------
# MongoDB variables
# --------------------------
variable "username_mongodb" {
  type    = string
  default = "mongodb-demo"
}

resource "random_password" "mongodb-password" {
  length           = 16
  special          = true
  override_special = "#$-_=+"
}

variable "provider_name_mongodb" {
  type    = string
  default = "TENANT"
}

variable "cloud_provider_mongodb" {
  type    = string
  default = "AWS"
}

variable "cloud_region_mongodb" {
  type    = string
  default = "EU_CENTRAL_1"
}

variable "provider_instance_size_name_mongodb" {
  type    = string
  default = "M0"
}

# --------------------------
# Confluent Cloud variables
# --------------------------
variable "env_name" {
  type    = string
  default = "demo-terraform"
}

variable "cluster_name" {
  type    = string
  default = "cc-demo-cluster"
}

variable "s3_bucket_prefix" {
  type    = string
  default = "cc-demo"
}

variable "cloud_provider" {
  type    = string
  default = "AWS"
}

variable "cloud_region" {
  type    = string
  default = "us-east-2"
}

variable "cc_package" {
  type    = string
  default = "ESSENTIALS"
}

variable "cc_availability" {
  type    = string
  default = "SINGLE_ZONE"
}
