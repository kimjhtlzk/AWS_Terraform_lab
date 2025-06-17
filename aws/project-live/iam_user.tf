locals {
    aws_iam_user = {
        # -----------------------------------------------------------------
        user1 = {
            policy = [  # 그룹권한이 아닌 특정유저에게 특정 권한을 추가하기 위함
            ]
            tags = { 
                "Membership" = "aaa"
            }
        }
        user2 = {
            policy = [  # 그룹권한이 아닌 특정유저에게 특정 권한을 추가하기 위함
            ]
            tags = { 
                "Membership" = "aaa"
            }
        }

    }
}

module "aws_iam_user" {
    source      = "i-gitlab.co.com/common/aws/iamuser"
    for_each    = local.aws_iam_user
    providers = {
        aws = aws.seoul
    }
    user_name   = each.key
    policy = [
        for policy_name in each.value.policy : coalesce(
        try(module.aws_iam_policy[policy_name].policy_arn, null),
        "arn:aws:iam::aws:policy/${policy_name}"
        )
    ]
    tags = each.value.tags

    depends_on = [ module.aws_iam_policy ]
}