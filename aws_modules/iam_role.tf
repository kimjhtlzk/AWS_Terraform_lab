locals {
    aws_iam_role = {
        # --------------------------------------------------------------------------
        "@owner" = {
          attach_policy = ["AdministratorAccess"] # null (or) policy name
          assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "AWS": "arn:aws:iam::13212132321:user/user1"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
        }
        "@admin" = {
          attach_policy = [ "IAMFullAccess", "AmazonVPCFullAccess","AmazonEC2FullAccess",
                            "AmazonS3FullAccess","AWSCertificateManagerFullAccess", "AmazonEKSAdminPolicy", 
                            "ReadOnlyAccess", "AWSSupportAccess", "ServiceQuotasFullAccess" ] # null (or) policy name
          assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::13212132321:user/user1",
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
        }
        "@SE" = {
          attach_policy = ["IAMFullAccess", "ReadOnlyAccess", "AWSSupportAccess", "ServiceQuotasFullAccess", "role_EC2_OnOff"] # null (or) policy name
          assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::13212132321:user/user1",
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
        }
        "@DBA" = {
          attach_policy = ["ReadOnlyAccess", "ServiceQuotasReadOnlyAccess", "role_DBA_backup"] # null (or) policy name
          assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::13212132321:user/user1",
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
        }
        "EC2_ReadOnly" = {
          attach_policy = ["AmazonEC2ReadOnlyAccess"] # null (or) policy name
          assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:AssumeRole"
      ],
      "Principal": {
        "Service": [
            "ec2.amazonaws.com"
        ]
      }
    }
  ]
}
EOF
        }

    }
}




module "aws_iam_role" {
    source      = "i-gitlab.c.com/common/aws/iamrole"
    for_each    = local.aws_iam_role
    providers = {
        aws = aws.seoul
    }
    role_name           = each.key
    attach_policy       = [
        for policy_name in each.value.attach_policy : coalesce(
        try(module.aws_iam_policy[policy_name].policy_arn, null),
        "arn:aws:iam::aws:policy/${policy_name}"
        )
    ]
    assume_role_policy  = each.value.assume_role_policy
}


