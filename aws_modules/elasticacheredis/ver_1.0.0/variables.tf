variable "elasticache_redis_name" {
  default = null
}
variable "engine_version" {
  default = null
}
variable "multi_az_enabled" {
  default = null
}
variable "auto_minor_version_upgrade" {
  default = null
}
variable "cluster_mode_enable" {
  default = null
}
variable "automatic_failover_enabled" {
  default = null
}
variable "node_type" {
  default = null
}
variable "num_node_groups" {
  default = null
}
variable "replicas_per_node_group" {
  default = null
}
variable "port" {
  default = null
}
variable "availability_zone" {
  default = null
}
variable "subnet_group_name" {
  default = null
}
variable "security_groups" {
  type    = list(string)
  default = []
}
variable "apply_immediately" {
  default = null
}
variable "notification_topic_arn" {
  default = null
}
variable "snapshot_retention_limit" {
  default = null
}
variable "snapshot_window" {
  default = null
}
variable "at_rest_encryption_enabled" {
  default = "false"
}
variable "data_tiering_enabled" {
  default = "false"
}
variable "transit_encryption_enabled" {
  default = "false"
}
variable "maintenance_window" {
  default = "tue:07:00-tue:08:00"
}