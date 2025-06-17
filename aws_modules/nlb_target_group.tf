locals {  # 그룹에 인스턴스를 넣을 때는 인스턴스가 running 상태여야합니다.
  aws_nlb_target_group = {
    # --------------------------------------------------------------------------
    seoul = {
      ihanni-seoul-instance-tg-03 = {
        target_type = "ip"  # "instance" or "ip"
        vpc         = "ihanni-seoul-vpc-01"

        protocol                  = "TCP"
        port                      = "80"

        health_check  = {
          protocol            = "TCP"
          port                = "traffic-port"
          interval            = "60"
          timeout             = "10"
          healthy_threshold   = "5"
          unhealthy_threshold = "3"
        }

        stickiness = {
          enabled         = "false"
          cookie_duration = "86400"
        }

        target = [  # instance name (target_type = "instance") or ip address (target_type = "ip")
          "ihanni-seoul-ec2-01",
        ]

      }

    }
  }
}


module "aws_seoul_nlb_target_group" {
  source      = "i-gitlab.co.com/common/aws/nlbtargetgroup"
  for_each    = local.aws_nlb_target_group.seoul

  providers = {
    aws = aws.seoul
  }

  group_name                = each.key
  target_type               = each.value.target_type
  vpc                       = module.aws_seoul_vpc[each.value.vpc].vpc_id
  protocol                  = each.value.protocol
  port                      = each.value.port
  health_check              = each.value.health_check
  stickiness                = each.value.stickiness
  target                    = each.value.target_type == "instance" ? [for target in each.value.target : module.aws_seoul_ec2[target].ec2_id] : [for target in each.value.target : module.aws_seoul_ec2[target].private_ip]

}