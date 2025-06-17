resource "aws_acm_certificate" "cert" {
  tags = merge(
    {
        Name = var.cert_name
    },
    try(var.tags, {})
  )
    certificate_body   = file(var.certificate_body)
    private_key        = file(var.private_key)
    certificate_chain  = file(var.certificate_chain)
}

