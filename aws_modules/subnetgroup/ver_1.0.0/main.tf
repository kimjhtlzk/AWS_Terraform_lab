resource "aws_elasticache_subnet_group" "subnet_group" {
  name        = var.subnet_group_name
  subnet_ids  = var.subnets
}
