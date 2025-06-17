locals {
  aws_vpc = {
    # --------------------------------------------------------------------------
    seoul = {
      vpc-ihanni-rnd = {
        cidr_block          = "10.11.0.0/16"
        instance_tenancy    = "default"
        use_ipv6_cidr_block = true
        subnets = [
          {
            subnet_name       = "subnet-ihanni-rnd-01"
            subnet_cidr       = "10.11.11.0/24"
            ipv6_cidr_block   = "2406:da12:c07:4000::/64"
            availability_zone = "ap-northeast-2a"
            autoassign_public = "true"
            tags = {
              "kubernetes.io/role/internal-eld" = "1"
            }
          },
          { 
            subnet_name       = "subnet-ihanni-rnd-02"
            subnet_cidr       = "10.11.12.0/24"
            ipv6_cidr_block   = "2406:da12:c07:4001::/64"
            availability_zone = "ap-northeast-2b"
            autoassign_public = "true"
            tags = { }
          },
          { 
            subnet_name       = "subnet-ihanni-rnd-03"
            subnet_cidr       = "10.11.13.0/24"
            ipv6_cidr_block   = null
            availability_zone = "ap-northeast-2a"
            autoassign_public = "false"
            tags = {
              "a" = "B"
              "c" = "D"
            }
          },
          { 
            subnet_name       = "subnet-ihanni-rnd-04"
            subnet_cidr       = "10.11.14.0/24"
            ipv6_cidr_block   = null
            availability_zone = "ap-northeast-2b"
            autoassign_public = "false"
            tags = {
              "a" = "B"
              "c" = "D"
            }
          },



        ]
      }

    }
  # --------------------------------------------------------------------------


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
# --------------------------------------------------------------------------