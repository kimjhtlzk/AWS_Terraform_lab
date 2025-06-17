resource "aws_lb_target_group" "nlb_target_group" {
  target_type                       = var.target_type
  vpc_id                            = var.vpc
  name                              = var.group_name

  protocol                          = var.protocol
  port                              = var.port
  preserve_client_ip                = var.target_type == "ip" ? false : true
  proxy_protocol_v2                 = "false" # 고정값

  connection_termination            = "false" # 고정값
  ip_address_type                   = "ipv4" # 고정값
  load_balancing_cross_zone_enabled = "use_load_balancer_configuration" # 고정값

  health_check {
    enabled             = "true"    # 고정값
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }


  stickiness {
    cookie_duration = var.stickiness.cookie_duration
    enabled         = var.stickiness.enabled
    type            = "source_ip"   # 고정값
  }

  deregistration_delay   = "300"    # 고정값

}

# if... instance target group
resource "aws_lb_target_group_attachment" "lb_instance_target_group_att" {
    for_each    = var.target_type == "instance" ? { for idx, target in var.target : idx => target } : {}

    target_group_arn = aws_lb_target_group.nlb_target_group.arn
    target_id        = each.value
}

# if... ip target group
resource "aws_lb_target_group_attachment" "lb_ip_target_group_att" {
    for_each    = var.target_type == "ip" ? { for idx, target in var.target : idx => target } : {}

    target_group_arn = aws_lb_target_group.nlb_target_group.arn
    target_id        = each.value
}
