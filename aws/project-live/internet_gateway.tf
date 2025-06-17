locals {
    aws_internet_gateway = { # vpc에 할당하지 않으려면 vpc = "null"
        # --------------------------------------------------------------------------
        seoul = {
            # Seoul
            igw-vpc-asd-live-default = { vpc = "vpc-asdas-live" }

        }
        tokyo = {
            # Global
            igw-vpc-asd-live-default = { vpc = "vpc-asdas-live" }

        }
    }
}


module "aws_seoul_internet_gateway" {
    source      = "i-gitlab.c.com/common/aws/internetgateway"
    for_each    = local.aws_internet_gateway.seoul

    providers = {
        aws = aws.seoul
    }

    igw_name    = each.key
    vpc         = each.value.vpc != "null" ? module.aws_seoul_vpc[each.value.vpc].vpc_id : "null"

}
# --------------------------------------------------------------------------
module "aws_tokyo_internet_gateway" {
    source      = "i-gitlab.c.com/common/aws/internetgateway"
    for_each    = local.aws_internet_gateway.tokyo

    providers = {
        aws = aws.tokyo
    }

    igw_name    = each.key
    vpc         = each.value.vpc != "null" ? module.aws_tokyo_vpc[each.value.vpc].vpc_id : "null"

}