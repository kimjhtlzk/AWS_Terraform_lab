locals {
    aws_iam_group = { 
        # Infra C Team Bacic Group
        Infra-Common = {
            policy = [
                # "AdministratorAccess", # 팀프로젝트가 아니면 이건 제외해야함
                "IAMReadOnlyAccess",
                "IAMUserChangePassword",
                "ReadOnlyAccess",
                "I_MFA", # -> Custom Policy
                "I-serial-console", # -> Custom Policy
                "IC-Office", # -> Custom Policy
                "role_EKS", # -> Custom Policy
            ]
            users = [
                "user1"
            ]
        }
        # Infra-Owner = {
        #     policy = [
        #         "AdministratorAccess",
        #     ]
        #     users = [
        #         "limsm",
        #     ]
        # }
        Infra-Admin = {
            policy = [
                "IAMFullAccess",
                "AmazonVPCFullAccess",
                "AmazonEC2FullAccess",
                "AmazonS3FullAccess",
                # "AWSMarketplaceFullAccess",
                "ElasticLoadBalancingFullAccess",
                "AWSCertificateManagerFullAccess",
                "AmazonEC2ContainerRegistryFullAccess",
                "AmazonEKSAdminPolicy", # -> Custom Policy
            ]
            users = [
                "user1"
            ]
        }
        Infra-SE = {
            policy = [
                "IAMFullAccess",
            ]
            users = [
                "user1"
            ]
        }
        Infra-DBA = {
            policy = [

            ]
            users = [
                "user1"
            ]
        }

        k8sadmin = {
            policy = [
                "role_k8sadmin_policy" # -> Custom Policy
            ]
            users = [
                "user1"
            ]
        }        

    }
}


module "aws_iam_group" {
    source      = "i-gitlab.c.com/common/aws/iamgroup"
    for_each    = local.aws_iam_group
    providers = {
        aws = aws.seoul
    }
    group_name  = each.key

    policy = [
        for policy_name in each.value.policy : coalesce(
        try(module.aws_iam_policy[policy_name].policy_arn, null),
        "arn:aws:iam::aws:policy/${policy_name}"
        )
    ]

    user_name   = each.value.users

    depends_on = [ module.aws_iam_user, module.aws_iam_policy ]
}


