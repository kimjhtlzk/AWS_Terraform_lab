resource "aws_iam_group" "group" {
  name = var.group_name
  path = "/"
}

# data "aws_iam_policy" "iam_policy" {
#   for_each = { for policy in var.policy : policy => policy }

#   name = each.value
# }

resource "aws_iam_group_policy_attachment" "iam_group_policy_attach" {
  for_each = { for policy in var.policy : policy => policy }

  group       = var.group_name
  policy_arn  = each.value
  
  depends_on  = [aws_iam_group.group]
}

resource "aws_iam_user_group_membership" "iam_user_group_attach" {
  for_each    = { for user in var.user_name : user => user }

  user        = each.value
  groups      = [var.group_name]

  depends_on  = [aws_iam_group.group]
}
