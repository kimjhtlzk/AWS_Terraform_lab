resource "aws_elasticache_replication_group" "replication_group" {
  replication_group_id       = var.elasticache_redis_name
  engine                     = "redis"
  engine_version             = var.engine_version
  multi_az_enabled           = var.multi_az_enabled
  automatic_failover_enabled = var.cluster_mode_enable == "true" ? true : var.automatic_failover_enabled

  node_type                  = var.node_type
  num_node_groups            = var.num_node_groups
  replicas_per_node_group    = var.replicas_per_node_group
  parameter_group_name       = var.cluster_mode_enable == "true" ? "default.redis7.cluster.on" : "default.redis7"
  port                       = var.port
 
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  data_tiering_enabled       = var.data_tiering_enabled

  auto_minor_version_upgrade = var.auto_minor_version_upgrade  
  maintenance_window         = var.maintenance_window

  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window

  subnet_group_name          = var.subnet_group_name
  transit_encryption_enabled = var.transit_encryption_enabled
  description                = " "

  security_group_ids         = var.security_groups != null ? var.security_groups : null

  apply_immediately          = var.apply_immediately
  
  notification_topic_arn     = var.notification_topic_arn
  

  log_delivery_configuration {
      destination      = "/aws/elasticache_redis/engine-log"
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
  }
  log_delivery_configuration {
      destination      = "/aws/elasticache_redis/slow-log"
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
  }

}
