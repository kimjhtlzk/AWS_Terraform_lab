resource "aws_lb" "nlb" {
  name                             = var.nlb_name
  internal                         = var.lb_type == "external" ? false : true
  load_balancer_type               = "network"  # 고정값

  ip_address_type                  = "ipv4" # 고정값
  enable_cross_zone_load_balancing = "false"    # 고정값
  enable_deletion_protection       = "true"    # 고정값

  subnet_mapping {
    subnet_id = var.subnet
    private_ipv4_address = var.lb_type == "external" ? null : var.private_ip
  }
  
  tags = var.tags
}


data "aws_lb_target_group" "target_group" {
  for_each = { for idx, listener in var.listener : idx => listener }

  name = each.value.target_group
}

resource "aws_lb_listener" "lb_listener" {
  for_each          = var.listener

  load_balancer_arn = aws_lb.nlb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    target_group_arn = data.aws_lb_target_group.target_group[each.key].arn
    type             = "forward"
  }

}
