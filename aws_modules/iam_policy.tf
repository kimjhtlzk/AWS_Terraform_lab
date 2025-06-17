locals {
    aws_iam_policy = {
        # --------------------------------------------------------------------------
        Infra_MFA = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListActions",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:ListVirtualMFADevices",
                "iam:UpdateLoginProfile",
                "iam:ChangePassword"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowUserToCreateVirtualMFADevice",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice"
            ],
            "Resource": "arn:aws:iam::*:mfa/*"
        },
        {
            "Sid": "AllowUserToManageTheirOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:EnableMFADevice",
                "iam:GetMFADevice",
                "iam:ListMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Resource": "arn:aws:iam::*:user/$${aws:username}"
        },
        {
            "Sid": "AllowUserToDeactivateTheirOwnMFAOnlyWhenUsingMFA",
            "Effect": "Allow",
            "Action": [
                "iam:DeactivateMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::*:user/$${aws:username}"
            ],
            "Condition": {
                "Bool": {
                    "aws:MultiFactorAuthPresent": "true"
                }
            }
        },
        {
            "Sid": "BlockMostAccessUnlessSignedInWithMFA",
            "Effect": "Deny",
            "NotAction": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ListUsers",
                "iam:ListVirtualMFADevices",
                "iam:ResyncMFADevice",
                "iam:UpdateLoginProfile",
                "iam:ChangePassword"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
EOF
        }
        AmazonEKSAdminPolicy = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
EOF
        }
        InfraC-Office = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "NotIpAddress": {
                    "aws:SourceIp": [
                        "110.32.12.0/24",
                    ]
                },
                "Bool": {"aws:ViaAWSService": "false"}
            }
        }
    ]
}
EOF
        }
        Infra-serial-console = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:GetSerialConsoleAccessStatus",
                "ec2:EnableSerialConsoleAccess",
                "ec2:DisableSerialConsoleAccess"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "*"
        }
    ]
}
EOF
        }

        role_grafana = {
          policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Effect" : "Allow",
      "Action" : [
        "cloudwatch:DescribeAlarmsForMetric",
        "cloudwatch:DescribeAlarmHistory",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:ListMetrics",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetInsightRuleReport"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "logs:DescribeLogGroups",
        "logs:GetLogGroupFields",
        "logs:StartQuery",
        "logs:StopQuery",
        "logs:GetQueryResults",
        "logs:GetLogEvents"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "ec2:DescribeTags",
        "ec2:DescribeInstances",
        "ec2:DescribeRegions"
      ],
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : "tag:GetResources",
      "Resource" : "*"
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "oam:ListSinks",
        "oam:ListAttachedLinks"
      ],
      "Resource" : "*"
    }
  ]
}
EOF
        }
        role_cspm = {
          policy = <<EOF
{
  "Version" : "2012-10-17",
  "Statement" : [
    {
      "Sid": "TatumCSPMRead",
      "Effect" : "Allow",
      "Action" : [
        "ce:GetCostAndUsage",
        "backup:GetBackupSelection",
        "backup:ListBackupPlans",
        "backup:ListBackupSelections",
        "backup:ListTags",
        "ec2:GetSerialConsoleAccessStatus",
        "eks:ListAddons",
        "eks:DescribeAddon",
        "cloudtrail:ListTrails",
        "apigateway:Get*",
        "wafv2:GetLoggingConfiguration",
        "macie2:DescribeBuckets",
        "s3:ListBucket",
        "s3:GetBucketPublicAccessBlock",
        "sso-directory:SearchGroups",
        "sso-directory:SearchUsers",
        "sso-directory:ListMembersInGroup",
        "sso:GetInlinePolicyForPermissionSet",
        "waf:List*",
        "waf:Get*",
        "waf-regional:List*",
        "waf-regional:Get*",
        "elasticfilesystem:DescribeAccessPoints"
      ],
      "Resource" : "*",
      "Condition": {
        "NotIpAddress": {
            "aws:SourceIp": [
                "4.12.33.105/32",
            ]
        },
        "Bool": {"aws:ViaAWSService": "false"}
      }
    }
  ]
}
EOF
        }
        role_monitor = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "apigateway:GET",
                "athena:List*",
                "athena:Batch*",
                "athena:Get*",
                "autoscaling:Describe*",
                "batch:List*",
                "batch:Describe*",
                "cloudfront:Get*",
                "cloudfront:List*",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "config:Deliver*",
                "config:Describe*",
                "config:Get*",
                "config:List*",
                "dynamodb:BatchGet*",
                "dynamodb:Describe*",
                "dynamodb:Get*",
                "dynamodb:List*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "ec2:Describe*",
                "ec2:Get*",
                "ec2messages:Get*",
                "ecs:Describe*",
                "ecs:List*",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "elasticache:Describe*",
                "elasticache:List*",
                "elasticfilesystem:Describe*",
                "elasticloadbalancing:Describe*",
                "es:Describe*",
                "es:List*",
                "es:Get*",
                "es:ESHttpGet",
                "es:ESHttpHead",
                "events:Describe*",
                "events:List*",
                "events:Test*",
                "firehose:Describe*",
                "firehose:List*",
                "glue:Get*",
                "health:Describe*",
                "health:Get*",
                "health:List*",
                "iam:Generate*",
                "iam:Get*",
                "iam:List*",
                "iam:Simulate*",
                "kinesis:Describe*",
                "kinesis:Get*",
                "kinesis:List*",
                "lambda:List*",
                "lambda:Get*",
                "logs:Describe*",
                "logs:Get*",
                "logs:FilterLogEvents",
                "logs:ListTagsLogGroup",
                "logs:TestMetricFilter",
                "rds:Describe*",
                "rds:List*",
                "rds:Download*",
                "s3:Get*",
                "s3:List*",
                "s3:Head*",
                "sns:Get*",
                "sns:List*",
                "sns:Check*",
                "sqs:Get*",
                "sqs:List*",
                "sqs:Receive*",
                "tag:Get*"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "122.123.123.248/32"
                    ]
                }
            }
        }
    ]
}
EOF
        }

        role_EC2_OnOff = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:StartInstances",
                "ec2:StopInstances"
        ],
        "Resource": "*"
        }
    ]
}
EOF
        }

        
        monitor_policy = {
          policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "apigateway:GET",
                "athena:List*",
                "athena:Batch*",
                "athena:Get*",
                "autoscaling:Describe*",
                "batch:List*",
                "batch:Describe*",
                "cloudfront:Get*",
                "cloudfront:List*",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "config:Deliver*",
                "config:Describe*",
                "config:Get*",
                "config:List*",
                "dynamodb:BatchGet*",
                "dynamodb:Describe*",
                "dynamodb:Get*",
                "dynamodb:List*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "ec2:Describe*",
                "ec2:Get*",
                "ec2messages:Get*",
                "ecs:Describe*",
                "ecs:List*",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "elasticache:Describe*",
                "elasticache:List*",
                "elasticfilesystem:Describe*",
                "elasticloadbalancing:Describe*",
                "es:Describe*",
                "es:List*",
                "es:Get*",
                "es:ESHttpGet",
                "es:ESHttpHead",
                "events:Describe*",
                "events:List*",
                "events:Test*",
                "firehose:Describe*",
                "firehose:List*",
                "glue:Get*",
                "health:Describe*",
                "health:Get*",
                "health:List*",
                "iam:Generate*",
                "iam:Get*",
                "iam:List*",
                "iam:Simulate*",
                "kinesis:Describe*",
                "kinesis:Get*",
                "kinesis:List*",
                "lambda:List*",
                "lambda:Get*",
                "logs:Describe*",
                "logs:Get*",
                "logs:FilterLogEvents",
                "logs:ListTagsLogGroup",
                "logs:TestMetricFilter",
                "rds:Describe*",
                "rds:List*",
                "rds:Download*",
                "s3:Get*",
                "s3:List*",
                "s3:Head*",
                "sns:Get*",
                "sns:List*",
                "sns:Check*",
                "sqs:Get*",
                "sqs:List*",
                "sqs:Receive*",
                "tag:Get*"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "23.123.123.237/32"
                    ]
                }
            }
        }
    ]
}
EOF
        }
    }
}




module "aws_iam_policy" {
    source      = "i-gitlab.c.com/common/aws/iampolicy"
    for_each    = local.aws_iam_policy
    providers = {
        aws = aws.seoul
    }
    policy_name = each.key
    policy      = each.value.policy

}


