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
variable "cluster_name_mongodb" {
  type    = string
  default = "terraformDemo"
}

variable "database_mongodb" {
  type    = string
  default = "confluent_demo"
}

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
  default = "US_EAST_1"
}

variable "provider_instance_size_name_mongodb" {
  type    = string
  default = "M0"
}

# ----------------------------------------
# Confluent Cloud Kafka cluster variables
# ----------------------------------------
variable "cc_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "cc_cloud_region" {
  type    = string
  default = "us-east-1"
}

variable "cc_env_name" {
  type    = string
  default = "demo-terraform"
}

variable "cc_cluster_name" {
  type    = string
  default = "cc-demo-cluster"
}

variable "cc_availability" {
  type    = string
  default = "SINGLE_ZONE"
}

# ------------------------------------------
# Confluent Cloud Schema Registry variables
# ------------------------------------------
variable "sr_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "sr_cloud_region" {
  type    = string
  default = "us-east-2"
}

variable "sr_package" {
  type    = string
  default = "ESSENTIALS"
}

