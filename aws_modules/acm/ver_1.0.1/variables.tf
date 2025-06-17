variable "certificates" {
  type = map(object({
    certificate_body = string  # bundle PEM 파일명 (ex: STAR.qpyou.cn.bundle.pem)
    private_key      = string  # key PEM 파일명 (ex: STAR.qpyou.cn.key.pem)
  }))
  description = "ACM 인증서용 bundle/key 파일명 매핑"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "ACM 리소스에 붙일 태그"
}

