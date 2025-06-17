locals {
  aws_route_table = {
    # --------------------------------------------------------------------------
    seoul = {
      # Live
      rt-live-public-subnet = {
        vpc          = "vpc-asdas-live"
        asso_subnets = ["public-live-subnet-a-1", "public-live-subnet-a-2",
                        "public-live-subnet-b-1", "public-live-subnet-c-1",
                        "public-live-elb-subnet-a-1", "public-live-elb-subnet-b-2" ] 
        rule = {
          1 ={
              cidr_block      = "0.0.0.0/0"
              resource_type   = "igw" # "igw" or "nat" or "peering"
              resource_name   = "igw-vpc-asdas-live-default" # "peering"은 이곳에 id를 직접 입력합니다.
          }
          2 ={
              cidr_block      = "10.11.0.0/16"
              resource_type   = "peering" # "igw" or "nat" or "peering"
              resource_name   = "pcx-445454" # "peering"은 이곳에 id를 직접 입력합니다.
          }
        }
      }



    }
  # --------------------------------------------------------------------------


  }
}


module "aws_seoul_route_table" {
  source    = "i-gitlab.co.com/common/aws/routetable"
  for_each  = local.aws_route_table.seoul

  providers = {
    aws = aws.seoul
  }

  route_table_name  = each.key
  vpc               = module.aws_seoul_vpc[each.value.vpc].vpc_id
  asso_subnets      = [for sub in each.value.asso_subnets : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]

  rule = [
    for rule in each.value.rule :
    {
      cidr_block    = rule.cidr_block
      resource_type = rule.resource_type
      resource_id   = rule.resource_type == "ngw" ? module.aws_seoul_nat_gateway[rule.resource_name].ngw_id : rule.resource_type == "igw" ? module.aws_seoul_internet_gateway[rule.resource_name].igw_id : rule.resource_type == "peering" ? rule.resource_name : null              
    }
  ]

  depends_on = [ module.aws_seoul_nat_gateway, module.aws_seoul_internet_gateway, module.aws_seoul_vpc ]
}

# --------------------------------------------------------------------------