locals {
    aws_sg = {
        # --------------------------------------------------------------------------
        seoul = {   # sg name cannot begin with sg-
            asdas-live-eks-gms-sg = {
                vpc = "vpc-asdas-live"
                rules = {
                    1 = {
                        rule_name   = "gms_hivase"  # 서브넷 단위 '내부 통신' open 시 0-65535 port range로 IN/E gress 모두 작성해야합니다.
                        rule_type   = "ingress"
                        # cidr_blocks = "13.124.83.83/32,52.78.11.220/32,3.34.204.168/32,3.35.59.227/32,43.202.201.239/32,43.200.188.52/32,43.155.155.10/32,183.111.229.82/32,183.111.229.83/32,52.79.76.25/32,3.37.22.75/32,34.64.71.108/32,34.64.53.93/32,34.64.247.183/32,34.64.159.69/32,34.64.135.210/32,34.64.141.116/32,125.132.73.146/32,13.209.223.150/32,15.165.189.10/32"
                        cidr_blocks = "11.456.78.0/32"
                        protocol    = "tcp"
                        from_port   = 80
                        to_port     = 80
                    },
                    5 = {
                        rule_name   = "call-sda"  # 서브넷 단위 '내부 통신' open 시 0-65535 port range로 IN/E gress 모두 작성해야합니다.
                        rule_type   = "ingress"
                        cidr_blocks = "11.456.78.0/32"
                        protocol    = "tcp"
                        from_port   = 443
                        to_port     = 443
                    },                    
                }
            }
        }
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

