# Create free tier cluster (only one allowed per project)
resource "mongodbatlas_cluster" "cluster-demo" {
  project_id                  = data.external.env_vars.result.MONGODB_ATLAS_PROJECT_ID
  name                        = "demo"
  provider_name               = var.provider_name_mongodb
  backing_provider_name       = var.cloud_provider_mongodb
  provider_region_name        = var.cloud_region_mongodb
  provider_instance_size_name = var.provider_instance_size_name_mongodb
  lifecycle {
    prevent_destroy = false
  }
}
output "standard_srv" {
  # Connection string
  value = mongodbatlas_cluster.cluster-demo.connection_strings[0].standard_srv
}

# Whitelist IP Address
resource "mongodbatlas_project_ip_access_list" "my-public-ip" {
  project_id = data.external.env_vars.result.MONGODB_ATLAS_PROJECT_ID
  cidr_block = data.external.env_vars.result.MONGODB_ATLAS_PUBLIC_IP_ADDRESS
  comment    = "cidr block for demo"
  lifecycle {
    prevent_destroy = false
  }
}

# Create DB user
resource "mongodbatlas_database_user" "mongodb-user" {
  username           = var.username_mongodb
  password           = random_password.mongodb-password.result
  project_id         = data.external.env_vars.result.MONGODB_ATLAS_PROJECT_ID
  auth_database_name = "admin"
  roles {
    role_name     = "dbAdmin"
    database_name = "confluent_demo"
  }
  roles {
    role_name     = "readWrite"
    database_name = "confluent_demo"
  }
  lifecycle {
    prevent_destroy = false
  }
}
output "mongodb-password" {
  value     = random_password.mongodb-password.result
  sensitive = true
}
