locals {
  aws_alb = {
    # --------------------------------------------------------------------------
    seoul = {
      asdsad-staging-review-alb-01 = {
        vpc                 = "vpc-asdas-staging"
        lb_type             = "external"   # "external" or "internal"
        idle_timeout        = "60"
        security_groups     = [
            "asdas-staging-ext-alb-sg",
        ]
        cross_zone_subnet   = [ # 서브넷 2개 입력
            "public-staging-subnet-a-1",
            "public-staging-subnet-b-1"
        ]

        listener = { # certificate_name값은 acm.tf로 정의된 인증서라면 acm.tf에서 정의한 이름을, 그렇지 않을 경우 arn을 직접 입력합니다.
          1 = {
            port                = 30000
            protocol            = "HTTPS"
            target_group        = "asdasd-staging-tg-01"
            certificate_name    = "arn:aws:acm:ap-northeast-2:45645645:certificate/asdasd-142d-213-asa-698604c1eef3"
          }
          2 = {
            port                = 30010
            protocol            = "HTTPS"
            target_group        = "asdas-staging-tg-02"
            certificate_name    = "arn:aws:acm:ap-northeast-2:45645654:certificate/asdasds-142d-332-dsds-698604c1eef3"
          }


        }

      }


    }


  }
}


module "aws_seoul_alb" {
  source    = "i-gitlab.co.com/common/aws/alb"
  for_each  = local.aws_alb.seoul

  providers = {
    aws = aws.seoul
  }
  
  alb_name          = each.key
  lb_type           = each.value.lb_type
  idle_timeout      = each.value.idle_timeout
  security_groups   = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.aws_seoul_sg[sg_name].security_group_id] : null
  cross_zone_subnet = [for sub in each.value.cross_zone_subnet : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]
  listener = {
    for idx, listener_data in each.value.listener:
      idx => merge(listener_data, {
        certificate  = try(module.aws_seoul_acm[listener_data.certificate_name].cert_arn, listener_data.certificate_name),
        target_group = module.aws_seoul_alb_target_group[listener_data.target_group].tg_arn
      })
  }
  tags              = merge(try(each.value.tags, {}), local.project_map_tag)
  depends_on        = [ module.aws_seoul_alb_target_group ]
}

