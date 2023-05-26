# --------------------------------------------------------
# Service Accounts (ksqlDB)
# --------------------------------------------------------
resource "confluent_service_account" "ksql" {
  display_name = "ksql-${random_id.id.hex}"
  description  = local.description
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Role Bindings (ksqlDB, ksqlDB for SR)
# --------------------------------------------------------
resource "confluent_role_binding" "ksql_cluster_admin" {
  principal   = "User:${confluent_service_account.ksql.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.cc_kafka_cluster.rbac_crn
  lifecycle {
    prevent_destroy = false
  }
}
resource "confluent_role_binding" "ksql_sr_resource_owner" {
  principal   = "User:${confluent_service_account.ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", confluent_schema_registry_cluster.cc_sr_cluster.resource_name, "subject=*")
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# ksqlDB Dev Cluster
# --------------------------------------------------------
resource "confluent_ksql_cluster" "ksqldb_dev_cluster" {
  display_name = "ksql-dev-cluster-${random_id.id.hex}"
  csu          = 1
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  credential_identity {
    id = confluent_service_account.ksql.id
  }
  depends_on = [
    confluent_role_binding.ksql_cluster_admin,
    confluent_role_binding.ksql_sr_resource_owner,
    confluent_role_binding.app_manager_environment_admin,
    confluent_role_binding.sr_environment_admin,
    confluent_role_binding.clients_cluster_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}
output "ksqldb_dev_cluster" {
  description = "CC ksqlDB Cluster ID"
  value       = resource.confluent_ksql_cluster.ksqldb_dev_cluster.id
}

# --------------------------------------------------------
# Credentials / API Keys (REST Management)
# --------------------------------------------------------
resource "confluent_api_key" "ksql_queries" {
  display_name = "ksql-queries-${var.cc_cluster_name}-key-${random_id.id.hex}"
  description  = local.description
  owner {
    id          = confluent_service_account.ksql.id
    api_version = confluent_service_account.ksql.api_version
    kind        = confluent_service_account.ksql.kind
  }
  managed_resource {
    id          = confluent_ksql_cluster.ksqldb_dev_cluster.id
    api_version = confluent_ksql_cluster.ksqldb_dev_cluster.api_version
    kind        = confluent_ksql_cluster.ksqldb_dev_cluster.kind
    environment {
      id = confluent_environment.cc_demo_env.id
    }
  }
  depends_on = [
    confluent_role_binding.ksql_cluster_admin
  ]
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# SQL Queries (Shell scripts)
# --------------------------------------------------------
resource "shell_script" "ksql_queries" {
  lifecycle_commands {
    create = file("${path.module}/shell/ksql_create.sh")
    delete = file("${path.module}/shell/ksql_delete.sh")
  }
  environment = {
    KSQLDB_ENDPOINT             = confluent_ksql_cluster.ksqldb_dev_cluster.rest_endpoint
    KSQLDB_BASIC_AUTH_USER_INFO = "${confluent_api_key.ksql_queries.id}:${confluent_api_key.ksql_queries.secret}"
  }
  working_directory = path.module
  depends_on = [
    confluent_api_key.ksql_queries,
    confluent_kafka_topic.users,
    confluent_kafka_topic.pageviews,
    confluent_connector.datagen_users,
    confluent_connector.datagen_pageviews
  ]
  lifecycle {
    prevent_destroy = false
  }
}
