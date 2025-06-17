locals {
    aws_sg = {
        # --------------------------------------------------------------------------
        seoul = {
            # basic- 이 rule은 기본 공통 rule입니다.
            basic-co-live-sg = {
                vpc = "vpc-asdsads-live"
                rules = {
                    1 = {
                        rule_name   = "basic-inbound-vpn"
                        rule_type   = "ingress"
                        cidr_blocks = "45.78.65.233/32"
                        protocol    = "tcp"
                        from_port   = 22
                        to_port     = 22
                    },
                    2 = {
                        rule_name   = "basic-inbound-vpn"
                        rule_type   = "ingress"
                        cidr_blocks = "45.78.65.233/32"
                        protocol    = "tcp"
                        from_port   = 3389
                        to_port     = 3389
                    },


                }

            }
        }
        # --------------------------------------------------------------------------

    }
}


module "aws_seoul_sg" {
    source              = "i-gitlab.co.com/common/aws/securitygroup"
    for_each            = local.aws_sg.seoul

    providers = {
        aws = aws.seoul
    }

    security_group_name = each.key
    vpc                 = module.aws_seoul_vpc[each.value.vpc].vpc_id

    rules = {
        for idx, rule in each.value.rules : idx => {
        rule_name   = rule.rule_name
        rule_type   = rule.rule_type
        cidr_blocks = rule.cidr_blocks
        protocol    = rule.protocol
        from_port   = rule.from_port
        to_port     = rule.to_port
        }
    }

}
