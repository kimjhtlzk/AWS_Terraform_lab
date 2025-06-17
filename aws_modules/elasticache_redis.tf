locals {
  aws_elasticache = {
    # --------------------------------------------------------------------------
    seoul = {
      asdasda-live-redis-cluster-01 = {
        engine_version             = "7.1"
        multi_az_enabled           = "false"    # 단일로 생성할 경우 "false"
        auto_minor_version_upgrade = "true"
        cluster_mode_enable        = "false"
        automatic_failover_enabled = "false"    # cluster_mode_enable의 값이 true이면 자동 true로 들어감

        node_type                  = "cache.m6g.large"
        num_node_groups            = "1"    # 샤드 수
        replicas_per_node_group    = "0"    # 샤드 당 노드 수. 단일로 생성할 경우 "0"
        port                       = "6379"

        availability_zone          = "ap-northeast-2a"
        subnet_group_name          = "asdasda-live-redis-subgroup-01"

        security_groups            = [ "asdsada-live-eks-sg" ]

        apply_immediately          = true
      }



    }


  }
}


module "aws_seoul_aws_elasticache" {
    source    = "i-gitlab.co.com/common/aws/elasticacheredis"
    for_each  = local.aws_elasticache.seoul

    providers = {
        aws = aws.seoul
    }
  
    elasticache_redis_name      = each.key
    engine_version              = each.value.engine_version
    multi_az_enabled            = each.value.multi_az_enabled
    auto_minor_version_upgrade  = each.value.auto_minor_version_upgrade
    cluster_mode_enable         = each.value.cluster_mode_enable
    automatic_failover_enabled  = each.value.automatic_failover_enabled
    node_type                   = each.value.node_type
    num_node_groups             = each.value.num_node_groups
    replicas_per_node_group     = each.value.replicas_per_node_group
    port                        = each.value.port
    availability_zone           = each.value.availability_zone
    subnet_group_name           = module.aws_seoul_subnet_group[each.value.subnet_group_name].subnet_group_name
    security_groups             = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.aws_seoul_sg[sg_name].security_group_id] : null
    apply_immediately           = each.value.apply_immediately

    notification_topic_arn      = aws_sns_topic.seoul_sns_topic.id

    snapshot_retention_limit    = each.value.snapshot_retention_limit
    snapshot_window             = each.value.snapshot_window
    maintenance_window          = try(each.value.maintenance_window, "tue:07:00-tue:08:00")    

    depends_on = [ module.aws_seoul_subnet_group ]
}
