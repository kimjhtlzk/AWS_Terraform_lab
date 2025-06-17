locals {
  aws_subnet_group = {
    # --------------------------------------------------------------------------
    seoul = {
      sdfsdf-load-redis-subgroup-01 = {
        vpc     = "vpc-sdfsdf-dev"
        subnets = ["subnet-load-01"]
      }

    }
  # --------------------------------------------------------------------------


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