resource "aws_iam_instance_profile" "instance_profile" {
  name = var.pf_name
  role = var.role
}