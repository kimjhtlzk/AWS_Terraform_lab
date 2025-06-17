locals {
  aws_acm = {
    seoul = {
      "2025_u_cn" = { ## 인증서 파일 통으로 사용, CA 인증서는 자동 분리 되도록 설정
       certificate_body = "2025_u.cn_crt.pem"
       private_key      = "2025_u.cn_key.pem"
      }
      "2025_c_com" = {
       certificate_body = "2025_s.com_crt.pem"
       private_key      = "2025_s.com_key.pem"
      }
    }
  }
}

module "aws_seoul_acm" {
  source    = "i-gitlab.co.com/common/aws/acm"

  providers = {
    aws = aws.seoul
  }

  certificates = local.aws_acm.seoul
}
