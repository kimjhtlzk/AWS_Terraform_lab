locals {
    aws_nat_gateway = { # 생성할 eip의 이름만 작성
        # --------------------------------------------------------------------------
        seoul = {
            # Live
            ngw-private-live-eks-subnet = {
                eip             = "eip-ngw-private-live-eks-subnet" # "true" or eip name
                vpc             = "vpc-sdfsdf-live"
                subnet          = [ "public-live-elb-subnet-a-1" ] 
                private_ip      = "10.12.16.250"
            }
        }
        # --------------------------------------------------------------------------
        tokyo = {
            # Global
            ngw-private-live-eks-gb-subnet = {
                eip             = "eip-ngw-private-live-eks-gb-subnet" # "true" or eip name
                vpc             = "vpc-sdfsdf-live"
                subnet          = [ "public-live-elb-gb-subnet-a-1" ] 
                private_ip      = "10.13.16.250"
            }
            # Japan
            ngw-private-live-eks-jp-subnet = {
                eip             = "eip-ngw-private-live-eks-jp-subnet" # "true" or eip name
                vpc             = "vpc-sdfsdfs-live"
                subnet          = [ "public-live-elb-jp-subnet-a-1" ] 
                private_ip      = "10.15.16.250"
            }            
        }
    }
}


module "aws_seoul_nat_gateway" {
    source      = "i-gitlab.co.com/common/aws/natgateway"
    for_each    = local.aws_nat_gateway.seoul

    providers = {
        aws = aws.seoul
    }

    ngw_name        = each.key
    eip             = each.value.eip == "true" ? "true" : module.aws_seoul_eip[each.value.eip].eip_id
    vpc             = module.aws_seoul_vpc[each.value.vpc].vpc_id
    subnet          = [for sub in each.value.subnet : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]
    private_ip      = each.value.private_ip

    depends_on      = [module.aws_seoul_eip]
}
# --------------------------------------------------------------------------
module "aws_tokyo_nat_gateway" {
    source      = "i-gitlab.co.com/common/aws/natgateway"
    for_each    = local.aws_nat_gateway.tokyo

    providers = {
        aws = aws.tokyo
    }

    ngw_name        = each.key
    eip             = each.value.eip == "true" ? "true" : module.aws_tokyo_eip[each.value.eip].eip_id
    vpc             = module.aws_tokyo_vpc[each.value.vpc].vpc_id
    subnet          = [for sub in each.value.subnet : module.aws_tokyo_vpc[each.value.vpc].subnets[sub].id]
    private_ip      = each.value.private_ip

    depends_on      = [module.aws_tokyo_eip]
}