resource "aws_iam_role" "role" {
  name                = var.role_name
  assume_role_policy  = var.assume_role_policy
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each = { for policy in var.attach_policy : policy => policy }

  role       = aws_iam_role.role.name
  policy_arn = each.value
}

