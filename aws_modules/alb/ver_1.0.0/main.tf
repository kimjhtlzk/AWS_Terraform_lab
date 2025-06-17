resource "aws_lb" "alb" {
  name                                        = var.alb_name
  internal                                    = var.lb_type == "external" ? false : true
  idle_timeout                                = var.idle_timeout
  load_balancer_type                          = "application"
  
  enable_deletion_protection                  = "true"
  enable_http2                                = "true"
  enable_tls_version_and_cipher_suite_headers = "false"
  enable_waf_fail_open                        = "false"
  enable_xff_client_port                      = "false"
  desync_mitigation_mode                      = "defensive"
  drop_invalid_header_fields                  = "false"
  enable_cross_zone_load_balancing            = "true"
  ip_address_type                             = "ipv4"
  preserve_host_header                        = "false"
  xff_header_processing_mode                  = "append"

  security_groups                             = var.security_groups
  subnets                                     = var.cross_zone_subnet

  tags = var.tags
}

resource "aws_lb_listener" "lb_listener" {
  for_each          = var.listener

  load_balancer_arn = aws_lb.alb.arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    target_group_arn = each.value.target_group
    type             = "forward"
  }

  certificate_arn   = each.value.protocol == "HTTPS" ? each.value.certificate : null
  ssl_policy        = each.value.protocol == "HTTPS" ? "ELBSecurityPolicy-TLS13-1-2-2021-06" : null
}


# 인증서
resource "aws_lb_listener_certificate" "lb_listener_certificate" {
  for_each = { for idx, listener in var.listener : idx => listener if listener.protocol == "HTTPS" }

  listener_arn    = aws_lb_listener.lb_listener[each.key].arn
  certificate_arn = each.value.certificate
}

