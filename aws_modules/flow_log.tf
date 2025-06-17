locals {
  aws_flow_log = {
    # --------------------------------------------------------------------------
    seoul = {   
      vpc-starseedgb-live-flow-log = {
        vpc_name                  = "vpc-asdada-live"
        s3_arn                    = "arn:aws:s3:::seoul-vpc-logging"
        traffic_type              = "REJECT"
        max_aggregation_interval  = 600
      }
      vpc-starseedgb-staging-flow-log = {
        vpc_name                  = "vpc-adasdas-staging"
        s3_arn                    = "arn:aws:s3:::seoul-vpc-logging"
        traffic_type              = "REJECT"
        max_aggregation_interval  = 600
      }
    }
  }
}



# --------------------------------------------------------------------------
module "aws_seoul_flow_log" {
  source                      = "i-gitlab.co.com/common/aws/flowlog"
  for_each                    = local.aws_flow_log.seoul

  providers = {
    aws = aws.seoul
  }

  flow_log_name              = each.key
  vpc_name                   = module.aws_seoul_vpc[each.value.vpc_name].vpc_id
  s3_arn                     = each.value.s3_arn 
  traffic_type               = each.value.traffic_type
  max_aggregation_interval   = each.value.max_aggregation_interval

}

