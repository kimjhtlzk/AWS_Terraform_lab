locals {
  # 인증서 분리
  pem_blocks_map = {
    for name, cert in var.certificates : name => regexall(
      "-----BEGIN CERTIFICATE-----[\\s\\S]+?-----END CERTIFICATE-----",
      trimspace(file("${path.module}/certs/${cert.certificate_body}"))
    )
  }

  # 서버 인증서
  server_cert_map = {
    for name, blocks in local.pem_blocks_map :
    name => blocks[0]
  }

  # 체인 인증서
  chain_cert_map = {
    for name, blocks in local.pem_blocks_map :
    name => length(blocks) > 1 ? join("\n", slice(blocks, 1, length(blocks))) : ""
  }
}

resource "aws_acm_certificate" "cert" {
  for_each = var.certificates

  tags = merge(
    { Name = each.key },
    var.tags
  )

  certificate_body = local.server_cert_map[each.key]
  private_key = trimspace(file("${path.module}/certs/${each.value.private_key}"))
  certificate_chain = local.chain_cert_map[each.key]
}
