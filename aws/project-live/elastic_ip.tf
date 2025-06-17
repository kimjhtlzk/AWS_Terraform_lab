locals {
    aws_eip = { # 생성할 eip의 이름만 작성
        # --------------------------------------------------------------------------
        seoul = {
            # Seoul
            eip-asdas-staging-server-01 = {}
        }
        # --------------------------------------------------------------------------
        tokyo = {
            eip-ngw-private-live-eks-gb-subnet = {}
        }

    }
}
 

module "aws_seoul_eip" {
    source                      = "i-gitlab.co.com/common/aws/eip"
    for_each                    = local.aws_eip.seoul

    providers = {
        aws = aws.seoul
    }

    eip_name                    = each.key
}
# --------------------------------------------------------------------------
module "aws_tokyo_eip" {
    source                      = "i-gitlab.co.com/common/aws/eip"
    for_each                    = local.aws_eip.tokyo

    providers = {
        aws = aws.tokyo
    }

    eip_name                    = each.key
}

