locals {
  description = "Resource created using terraform"
}

# --------------------------------------------------------
# This 'random_id' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
  byte_length = 4
}

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
