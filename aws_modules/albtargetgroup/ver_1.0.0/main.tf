resource "aws_lb_target_group" "alb_target_group" {
    target_type                         = var.target_type
    vpc_id                              = var.vpc
    name                                = var.group_name

    protocol                            = var.protocol
    port                                = var.port
    protocol_version                    = "HTTP1"   # 고정값
    slow_start                          = "0"   # 고정값

    ip_address_type                     = "ipv4"    # 고정값
    load_balancing_algorithm_type       = var.load_balancing_algorithm
    load_balancing_cross_zone_enabled   = "use_load_balancer_configuration" # 고정값

    health_check {
        enabled             = "true"    # 고정값
        protocol            = var.health_check.protocol
        port                = var.health_check.port
        path                = var.health_check.path
        interval            = var.health_check.interval
        timeout             = var.health_check.timeout
        healthy_threshold   = var.health_check.healthy_threshold
        unhealthy_threshold = var.health_check.unhealthy_threshold
        matcher             = var.health_check.matcher
    }

    dynamic "stickiness" {
        for_each = var.stickiness.enabled ? [1] : []
        content {
            enabled         = var.stickiness.enabled
            cookie_duration = var.stickiness.cookie_duration
            type            = var.stickiness.type
        }
    }

    deregistration_delay = "300"    # 고정값

}

# if... instance target group
resource "aws_lb_target_group_attachment" "lb_instance_target_group_att" {
    for_each    = var.target_type == "instance" ? { for idx, target in var.target : idx => target } : {}

    target_group_arn = aws_lb_target_group.alb_target_group.arn
    target_id        = each.value
}

# if... ip target group
resource "aws_lb_target_group_attachment" "lb_ip_target_group_att" {
    for_each    = var.target_type == "ip" ? { for idx, target in var.target : idx => target } : {}

    target_group_arn = aws_lb_target_group.alb_target_group.arn
    target_id        = each.value
}
