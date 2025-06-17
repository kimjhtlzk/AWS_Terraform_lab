locals {
    aws_instance_profile = { # 생성할 eip의 이름만 작성
        # --------------------------------------------------------------------------
        seoul = {
            pf-ec2-readonly = {
                role = "EC2_ReadOnly" # "true" or eip name
            }            
            pf-ec2-db = {
                role = "EC2_DB" # "true" or eip name
            }  
        }
        # --------------------------------------------------------------------------
    }
}


module "aws_seoul_instance_profile" {
    source      = "i-gitlab.co.com/common/aws/instanceprofile"
    for_each    = local.aws_instance_profile.seoul

    providers = {
        aws = aws.seoul
    }

    pf_name = each.key
    role    = each.value.role

    depends_on  = [module.aws_iam_role]
}

