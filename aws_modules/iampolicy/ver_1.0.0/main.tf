resource "aws_iam_policy" "policy" {
  name      = var.policy_name
  path      = "/"
  policy    = var.policy
}


