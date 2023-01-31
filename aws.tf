# --------------------------------------------------------
# Connectors
# --------------------------------------------------------
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket_prefix}-${random_id.id.hex}"
  tags = {
    Name        = local.description
    Environment = "Dev"
  }
  lifecycle {
    prevent_destroy = false
  }
}

# --------------------------------------------------------
# Confluent Cloud Connectors
# --------------------------------------------------------
# s3_sink
resource "confluent_connector" "s3_sink" {
  environment {
    id = confluent_environment.cc_demo_env.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.cc_kafka_cluster.id
  }
  config_sensitive = {
    "aws.access.key.id"     = data.external.env_vars.result.AWS_ACCESS_KEY_ID
    "aws.secret.access.key" = data.external.env_vars.result.AWS_SECRET_ACCESS_KEY
  }
  config_nonsensitive = {
    "topics"                   = "dlq-accomplished_female_readers"
    "input.data.format"        = "AVRO"
    "connector.class"          = "S3_SINK"
    "name"                     = "S3_SINKConnector_0"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.connectors.id
    "s3.bucket.name"           = "${var.s3_bucket_prefix}-${random_id.id.hex}"
    "output.data.format"       = "JSON"
    "time.interval"            = "DAILY"
    "flush.size"               = "1000"
    "tasks.max"                = "1"
  }
  depends_on = [
    shell_script.ksql_queries,
    confluent_kafka_acl.connectors_source_consumer_group
  ]
  lifecycle {
    prevent_destroy = false
  }
}
