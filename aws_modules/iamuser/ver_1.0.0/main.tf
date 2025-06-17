resource "aws_iam_user" "iam_user" {
  force_destroy = "false"
  name          = var.user_name
  path          = "/"

  tags = var.tags  
}

resource "aws_iam_user_policy_attachment" "iam_user_policy_attach" {
    for_each = { for policy in var.policy : policy => policy }

    user        = var.user_name
    policy_arn  = each.value

    depends_on = [aws_iam_user.iam_user]
}