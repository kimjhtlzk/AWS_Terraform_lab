locals {
    aws_iam_group = { 
        aaa-Games = {
            policy = [
                "IAMReadOnlyAccess",
                "ReadOnlyAccess",
                "MojitoGames-Office",   # -> Custom Policy
                "Infra_MFA", # -> Custom Policy
                "IAMUserChangePassword",
                "role_EKS", # -> Custom Policy
                "ElasticLoadBalancingFullAccess",
                "Cloud9-User", # -> Custom Policy
            ]
            users = [
                "user4",
            ]
        }
        dfdd-common = {
            policy = [
                "IAMUserChangePassword",
                "ReadOnlyAccess",
                "Infra_MFA",
                "InfraC-Office"
            ]
            users = [
                "user3",
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
