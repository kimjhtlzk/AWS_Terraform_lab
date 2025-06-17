resource "aws_security_group" "sg" {
  tags = {
    Name = var.security_group_name
  }
  name   = var.security_group_name
  vpc_id = var.vpc
}

resource "aws_security_group_rule" "rules" {
  for_each = var.rules

  security_group_id = aws_security_group.sg.id
  description       = each.value.rule_name
  type              = each.value.rule_type
  cidr_blocks       = split(",", each.value.cidr_blocks)
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
}


# resource "aws_vpc_security_group_ingress_rule" "ingress_rule" {
#   for_each = var.ingress_rules

#   security_group_id = aws_security_group.sg.id
#   description       = each.value.rule_name
#   cidr_ipv4         = each.value.cidr_blocks
#   ip_protocol       = each.value.protocol
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
# }

# resource "aws_vpc_security_group_egress_rule" "egress_rule" {
#   for_each = var.egress_rules

#   security_group_id = aws_security_group.sg.id
#   description       = each.value.rule_name
#   cidr_ipv4         = each.value.cidr_blocks
#   ip_protocol       = each.value.protocol
#   from_port         = each.value.from_port
#   to_port           = each.value.to_port
# }


