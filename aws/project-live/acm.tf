locals {
  aws_acm = {   # 인증서 각 파일들의 파일명을 작성합니다.
    # --------------------------------------------------------------------------
    seoul = {
    #   u_cn_230803-1 = {
    #     issue_date        = "230803"  # 인증서 발급 날짜 / 의미 없는 값으로 단순 기록용으로 사용함.
    #     certificate_body   = "u.cn.crt"
    #     private_key        = "u.cn.key"
    #     certificate_chain  = "chainca.crt"
    #   }
    }
    # --------------------------------------------------------------------------
    tokyo = {
    #   u_cn_230803-1 = {
    #     issue_date        = "230803"  # 인증서 발급 날짜 / 의미 없는 값으로 단순 기록용으로 사용함.
    #     certificate_body   = "u.cn.crt"
    #     private_key        = "u.cn.key"
    #     certificate_chain  = "chainca.crt"
    #   }
    }
  }
}


module "aws_seoul_acm" {
  source    = "i-gitlab.co.com/common/aws/acm"
  version = "1.0.0"
  for_each  = local.aws_acm.seoul

  providers = {
    aws = aws.seoul
  }
  
  cert_name         = each.key
  certificate_body  = each.value.certificate_body
  private_key       = each.value.private_key
  certificate_chain = each.value.certificate_chain
  tags              = local.project_map_tag
}
#---------------------------------------------------------------------------------

module "aws_tokyo_acm" {
  source    = "i-gitlab.co.com/common/aws/acm"
  version = "1.0.0"
  for_each  = local.aws_acm.tokyo

  providers = {
    aws = aws.tokyo
  }
  
  cert_name         = each.key
  certificate_body  = each.value.certificate_body
  private_key       = each.value.private_key
  certificate_chain = each.value.certificate_chain
  tags              = local.project_map_tag  
}