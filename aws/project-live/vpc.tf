locals {
  aws_vpc = {
    # --------------------------------------------------------------------------
    seoul = {
      # Live
      vpc-asda-live = {
        cidr_block          = "10.12.0.0/16"
        instance_tenancy    = "default"
        use_ipv6_cidr_block = false

        subnets = [
          # ec2 / redis (사용 가능한 연속된 숫자로 사용)
          { 
            subnet_name       = "public-live-subnet-a-1"
            subnet_cidr       = "10.12.0.0/22"
            ipv6_cidr_block   = null
            availability_zone = "ap-northeast-2a"
            autoassign_public = "true"
            tags = {}
          }
        ]
      }


    }
  }
}


module "aws_seoul_vpc" {
  source    = "i-gitlab.co.com/common/aws/vpc"
  for_each  = local.aws_vpc.seoul

  providers = {
    aws = aws.seoul
  }
  
  vpc_name            = each.key
  cidr_block          = each.value.cidr_block
  instance_tenancy    = each.value.instance_tenancy
  use_ipv6_cidr_block = each.value.use_ipv6_cidr_block
  subnets             = each.value.subnets

}
