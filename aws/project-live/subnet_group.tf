locals {
  aws_subnet_group = {
    # --------------------------------------------------------------------------
    seoul = {
      asdas-live-subgroup-01 = {
        vpc     = "vpc-asdasd-live"
        subnets = ["private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1"]
      }
    }
  # --------------------------------------------------------------------------
    tokyo = {
      # Global
      adasd-live-subgroup-01 = {
        vpc     = "vpc-adasd-live"
        subnets = ["private-live-etc-gb-subnet-a-1", "private-live-etc-gb-subnet-c-1"]
      }
    }

  }
}


module "aws_seoul_subnet_group" {
    source    = "i-gitlab.co.com/common/aws/subnetgroup"
    for_each  = local.aws_subnet_group.seoul

    providers = {
        aws = aws.seoul
    }
  
    subnet_group_name = each.key
    subnets           = [for sub in each.value.subnets : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]

}
# --------------------------------------------------------------------------
module "aws_tokyo_subnet_group" {
    source    = "i-gitlab.co.com/common/aws/subnetgroup"
    for_each  = local.aws_subnet_group.tokyo

    providers = {
        aws = aws.tokyo
    }
  
    subnet_group_name = each.key
    subnets           = [for sub in each.value.subnets : module.aws_tokyo_vpc[each.value.vpc].subnets[sub].id]

}