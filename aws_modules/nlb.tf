locals {
  aws_nlb = {
    # --------------------------------------------------------------------------
    seoul = {
      ihanni-seoul-test-nlb-01 = {
        vpc                 = "ihanni-seoul-vpc-01"
        lb_type             = "external"   # "external" or "internal"
        idle_timeout        = "60"
        security_groups     = [
            "basic-ihanni-seoul-vpc-01-sg",
            # "ihanni-seoul-sg-02"
        ]

        subnet      = "ihanni-seoul-vpc-01-subnet-01"
        private_ip  = "null"

        listener = {
          1 = {
            port                = 80
            protocol            = "TCP"
            target_group        = "ihanni-seoul-instance-tg-03"
          }
        }

      }
      ihanni-seoul-test-nlb-02 = {
        vpc                 = "ihanni-seoul-vpc-01"
        lb_type             = "internal"   # "external" or "internal"
        idle_timeout        = "60"
        security_groups     = [
            "basic-ihanni-seoul-vpc-01-sg",
            # "ihanni-seoul-sg-02"
        ]

        subnet      = "ihanni-seoul-vpc-01-subnet-01"
        private_ip  = "10.10.11.6"

        listener = {
          1 = {
            port                = 8080
            protocol            = "TCP"
            target_group        = "ihanni-seoul-instance-tg-04"
          }
        }

      }
    }
    # --------------------------------------------------------------------------
  }
}


module "aws_seoul_nlb" {
  source    = "i-gitlab.co.com/common/aws/nlb"
  for_each  = local.aws_nlb.seoul

  providers = {
    aws = aws.seoul
  }
  
  nlb_name          = each.key
  lb_type           = each.value.lb_type
  idle_timeout      = each.value.idle_timeout
  security_groups   = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.aws_seoul_sg[sg_name].security_group_id] : null
  subnet            = module.aws_seoul_vpc[each.value.vpc].subnets[each.value.subnet].id
  private_ip        = each.value.lb_type == "external" ? "null" : each.value.private_ip
  listener          = { for idx, listener_data in each.value.listener : idx => listener_data }
  tags              = merge(try(each.value.tags, {}), local.project_map_tag)
  depends_on        = [ module.aws_seoul_nlb_target_group ]
}