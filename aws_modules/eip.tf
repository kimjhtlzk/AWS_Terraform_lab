locals {
    aws_eip = { # 생성할 eip의 이름만 작성
        # --------------------------------------------------------------------------
        seoul = {
            # ihanni-seoul-eip-01 = {}
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