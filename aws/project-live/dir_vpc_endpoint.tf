locals {
    aws_vpc_endpoint = { # 생성할 eip의 이름만 작성
        # --------------------------------------------------------------------------
        seoul = {
            # ep-vpc-sdfsd-live = {
            #     region  = "ap-northeast-2" # "true" or eip name
            #     vpc     = "vpc-sdfsdf-live"
            # }
        }
        # --------------------------------------------------------------------------
        tokyo = {
            # ep-vpc-asdsa-live = {
            #     region  = "ap-northeast-1" # "true" or eip name
            #     vpc     = "vpc-asdasd-live"
            # }
        }
    }
}


module "aws_seoul_vpc_endpoint" {
    source      = "./modules/vpc_endpoint/ver_1.0.0"
    for_each    = local.aws_vpc_endpoint.seoul

    providers = {
        aws = aws.seoul
    }

    ep_name = each.key
    region  = each.value.region
    vpc_id  = module.aws_seoul_vpc[each.value.vpc].vpc_id

}

module "aws_tokyo_vpc_endpoint" {
    source      = "./modules/vpc_endpoint/ver_1.0.0"
    for_each    = local.aws_vpc_endpoint.tokyo

    providers = {
        aws = aws.tokyo
    }

    ep_name = each.key
    region  = each.value.region
    vpc_id  = module.aws_tokyo_vpc[each.value.vpc].vpc_id

}