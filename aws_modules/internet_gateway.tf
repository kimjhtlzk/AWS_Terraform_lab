locals {
    aws_internet_gateway = { # vpc에 할당하지 않으려면 vpc = "null"
        # --------------------------------------------------------------------------
        seoul = {
            # igw-public-eks-subnet = { vpc = "null" }   
        }

    }
}


module "aws_seoul_internet_gateway" {
    source      = "i-gitlab.co.com/common/aws/internetgateway"
    for_each    = local.aws_internet_gateway.seoul

    providers = {
        aws = aws.seoul
    }

    igw_name    = each.key
    vpc         = each.value.vpc != "null" ? module.aws_seoul_vpc[each.value.vpc].vpc_id : "null"

}
