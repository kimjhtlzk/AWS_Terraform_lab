locals {
    aws_iam_user = {
        # -----------------------------------------------------------------

        monitor = {    # 모히또게임즈 서비스용 계정
            policy = [  # 그룹권한이 아닌 특정유저에게 특정 권한을 추가하기 위함
                "AmazonEC2ReadOnlyAccess",
                "ReadOnlyAccess",
                "role_monitor"
            ]
        }

        grafana = {    # 인프라기술C팀 그라파나 계정
            policy = [  # 그룹권한이 아닌 특정유저에게 특정 권한을 추가하기 위함
                "role_grafana", # "AmazonGrafanaCloudWatchAccess",
                "CloudWatchLogsReadOnlyAccess"
            ]
        }        

        # terraform = {
        #     policy = [
        #         "AmazonEC2FullAccess",
        #         "AdministratorAccess",
        #     ]
        # }
    }
}


module "aws_iam_user" {
    source      = "i-gitlab.c.com/common/aws/iamuser"
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



