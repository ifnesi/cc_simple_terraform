# -------------------------------------------------------
# Confluent Cloud Environment
# -------------------------------------------------------
resource "confluent_environment" "cc_demo_env" {
  display_name = "${var.env_name}-${random_id.id.hex}"
  lifecycle {
    prevent_destroy = false
  }
}
output "cc_demo_env" {
  description = "CC Environment"
  value       = resource.confluent_environment.cc_demo_env.id
}

# --------------------------------------------------------
# Schema Registry
# --------------------------------------------------------
data "confluent_schema_registry_region" "cc_demo_sr" {
  cloud   = var.cloud_provider
  region  = var.cloud_region
  package = var.cc_package
}
output "cc_demo_sr" {
  description = "CC Schema Registry Region"
  value       = data.confluent_schema_registry_region.cc_demo_sr
}
resource "confluent_schema_registry_cluster" "cc_sr_cluster" {
  package = data.confluent_schema_registry_region.cc_demo_sr.package
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  region {
    id = data.confluent_schema_registry_region.cc_demo_sr.id
  }
  lifecycle {
    prevent_destroy = false
  }
}
output "cc_sr_cluster" {
  description = "CC Cluster"
  value       = resource.confluent_schema_registry_cluster.cc_sr_cluster.id
}

# --------------------------------------------------------
# Apache Kafka Cluster
# --------------------------------------------------------
resource "confluent_kafka_cluster" "cc_kafka_cluster" {
  display_name = var.cluster_name
  availability = var.cc_availability
  cloud        = var.cloud_provider
  region       = var.cloud_region
  basic {}
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Service Accounts (app_manager, sr, clients)
# --------------------------------------------------------
resource "confluent_service_account" "app_manager" {
  display_name = "app-manager-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_service_account" "sr" {
  display_name = "sr-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_service_account" "clients" {
  display_name = "client-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Role Bindings (app_manager, sr, clients)
# --------------------------------------------------------
resource "confluent_role_binding" "app_manager_environment_admin" {
  principal   = "User:${confluent_service_account.app_manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.cc_demo_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "sr_environment_admin" {
  principal   = "User:${confluent_service_account.sr.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.cc_demo_env.resource_name
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "clients_cluster_admin" {
  principal   = "User:${confluent_service_account.clients.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cc_kafka_cluster.rbac_crn
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Credentials / API Keys
# --------------------------------------------------------
# app_manager
resource "confluent_api_key" "app_manager_kafka_cluster_key" {
  display_name = "app-manager-${var.cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.app_manager.id
    api_version = confluent_service_account.app_manager.api_version
    kind        = confluent_service_account.app_manager.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_demo_env.id
    }
  }
  depends_on = [
    confluent_role_binding.app_manager_environment_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
# Schema Registry
resource "confluent_api_key" "sr_cluster_key" {
  display_name = "sr-${var.cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.sr.id
    api_version = confluent_service_account.sr.api_version
    kind        = confluent_service_account.sr.kind
  }
  managed_resource {
    id          = confluent_schema_registry_cluster.cc_sr_cluster.id
    api_version = confluent_schema_registry_cluster.cc_sr_cluster.api_version
    kind        = confluent_schema_registry_cluster.cc_sr_cluster.kind
    environment {
      id = confluent_environment.cc_demo_env.id
    }
  }
  depends_on = [
    confluent_role_binding.sr_environment_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
# Kafka clients
resource "confluent_api_key" "clients_kafka_cluster_key" {
  display_name = "clients-${var.cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.clients.id
    api_version = confluent_service_account.clients.api_version
    kind        = confluent_service_account.clients.kind
  }
  managed_resource {
    id          = confluent_kafka_cluster.cc_kafka_cluster.id
    api_version = confluent_kafka_cluster.cc_kafka_cluster.api_version
    kind        = confluent_kafka_cluster.cc_kafka_cluster.kind
    environment {
      id = confluent_environment.cc_demo_env.id
    }
  }
  depends_on = [
    confluent_role_binding.clients_cluster_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
