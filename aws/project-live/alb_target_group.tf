locals {  # 그룹에 인스턴스를 넣을 때는 인스턴스가 running 상태여야합니다. 
  aws_alb_target_group = {
    # --------------------------------------------------------------------------
    seoul = {
      asdawsdas-staging-tg-01 = {
        vpc         = "vpc-asdasda-staging"

        protocol                  = "HTTP"
        port                      = "30000"
        load_balancing_algorithm  = "round_robin" # "round_robin"or "least_outstanding_requests"

        health_check  = {
          protocol            = "HTTP"
          port                = "traffic-port" # "traffic-port" or 0-65536
          path                = "/"
          interval            = "60"
          timeout             = "10"
          healthy_threshold   = "5"
          unhealthy_threshold = "3"
          matcher             = "200"
        }

        stickiness = {
          enabled         = "false" # false일 경우 stickiness블럭은 동작하지 않습니다.
          cookie_duration = "0"
          type            = "lb_cookie"
        }

        target_type = "instance"  # "instance" or "ip"
        target = [  # instance name (target_type = "instance") or ip address (target_type = "ip")
          "asdasdas-staging-server-01",
        ]

      }

    }

  }
}


module "aws_seoul_alb_target_group" {
  source      = "i-gitlab.c.com/common/aws/albtargetgroup"
  for_each    = local.aws_alb_target_group.seoul

  providers = {
    aws = aws.seoul
  }

  group_name                = each.key
  vpc                       = module.aws_seoul_vpc[each.value.vpc].vpc_id
  protocol                  = each.value.protocol
  port                      = each.value.port
  load_balancing_algorithm  = each.value.load_balancing_algorithm
  health_check              = each.value.health_check
  stickiness                = each.value.stickiness
  target_type               = each.value.target_type
  target                    = each.value.target_type == "instance" ? [for target in each.value.target : module.aws_seoul_ec2[target].ec2_id] : [for target in each.value.target : module.aws_seoul_ec2[target].private_ip]

}
