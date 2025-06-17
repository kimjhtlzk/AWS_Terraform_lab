locals {
    aws_cloud9 = { 
        sdfsd-dev-cloud9 = {
            cloud9_size         = "t3.small"
            vpc                 = "vpc-sdfsdf-dev"
            subnet              = "subnet-load-01"
            image               = "amazonlinux-2-x86_64"
            permissions_user    = [
                "arn:aws:iam::132132132:user/user1",

            ]
        }


    }
}




module "aws_seoul_cloud9" {
    source      = "i-gitlab.co.com/common/aws/cloud9"
    for_each    = local.aws_cloud9
    providers = {
        aws = aws.seoul
    }

    cloud9_name         = each.key
    cloud9_size         = each.value.cloud9_size
    subnet              = module.aws_seoul_vpc[each.value.vpc].subnets[each.value.subnet].id
    image               = each.value.image
    permissions_user    = each.value.permissions_user

    depends_on = [ module.aws_iam_user ]
}

