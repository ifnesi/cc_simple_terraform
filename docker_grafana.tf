# --------------------------------------------------------
# Start Prometheus/Grafana on local docker (Shell scripts)
# --------------------------------------------------------
resource "shell_script" "grafana" {
  lifecycle_commands {
    create = file("${path.module}/shell/start_grafana.sh")
    delete = file("${path.module}/shell/stop_grafana.sh")
  }
  environment = {
    CONFLUENT_CLOUD_API_KEY    = "${data.external.env_vars.result.CONFLUENT_CLOUD_API_KEY}"
    CONFLUENT_CLOUD_API_SECRET = "${data.external.env_vars.result.CONFLUENT_CLOUD_API_SECRET}"
    CCLOUD_KAFKA_LKC_IDS       = "${resource.confluent_kafka_cluster.cc_kafka_cluster.id}"
    CCLOUD_KSQL_LKSQLC_IDS     = "${resource.confluent_ksql_cluster.ksqldb_dev_cluster.id}"
    CCLOUD_SR_LSRC_IDS         = "${resource.confluent_schema_registry_cluster.cc_sr_cluster.id}"
    CCLOUD_CONNECT_LCC_IDS     = "${resource.confluent_connector.datagen_users.id},${resource.confluent_connector.datagen_pageviews.id},${resource.confluent_connector.mongo_db_sink.id}"
  }
  working_directory = path.module
  depends_on = [
    confluent_schema_registry_cluster.cc_sr_cluster,
    confluent_kafka_cluster.cc_kafka_cluster,
    confluent_ksql_cluster.ksqldb_dev_cluster,
    confluent_connector.datagen_users,
    confluent_connector.datagen_pageviews,
    confluent_connector.mongo_db_sink
  ]
  lifecycle {
    prevent_destroy = false
  }
}
