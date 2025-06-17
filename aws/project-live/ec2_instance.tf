locals {
  aws_ec2 = {
    # --------------------------------------------------------------------------
    seoul = {   
      ## Staging
      asdasd-staging-server-01 = {
        ami                         = "co-rocky8-basic"
        instance_type               = "m6i.large"
        availability_zone           = "ap-northeast-2a"

        vpc                         = "vpc-asdasd-staging"
        subnet                      = "public-staging-subnet-a-1"
        private_ip                  = "10.11.0.11"
        associate_public_ip_address = "eip-asdas-staging-server-01" # "true" or "false" or eip name
        security_groups             = [ "basic-com2us-staging-sg", "dsad-staging-common-sg", "asdas-staging-server-sg", "basic-com2us-staging-freeipa-sg" ] # if no security_groups = []

        root_ebs = {
          root_ebs_type = "gp3" # EBS 볼륨 유형 ([ssd]gp2, gp3 / [hdd] st1, standard)
          root_ebs_size = 50
          delete_on_termination = true
        }

        add_ebs = {
          1 = {
            add_ebs_type  = "gp3" # EBS 볼륨 유형 ([ssd]gp2, gp3 / [hdd] st1, standard)
            add_ebs_size  = 100
            add_ebs_path  = "/dev/xvdb"  # 마운트할 디바이스 이름
            iops          = 3000  # Only valid for type of io1, io2 or gp3. basic value = 3000
            throughput    = 125 # Only valid for type of gp3. basic value = 125
            snapshot_id   = "null"
          }
        }

        iam_instance_profile    = "pf-ec2-readonly"  # null (or) instance profile name
        disable_api_termination = true  # 종료방지
      }
    }

  }
}


module "aws_seoul_ec2" {
  source                      = "i-gitlab.co.com/common/aws/ec2"
  for_each                    = local.aws_ec2.seoul

  providers = {
    aws = aws.seoul
  }
  vpc                         = module.aws_seoul_vpc[each.value.vpc].vpc_id
  ec2_name                    = each.key
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  availability_zone           = each.value.availability_zone
  subnet                      = module.aws_seoul_vpc[each.value.vpc].subnets[each.value.subnet].id
  private_ip                  = each.value.private_ip
  associate_public_ip_address = each.value.associate_public_ip_address == "true" ? "true" : each.value.associate_public_ip_address == "false" ? "false" : module.aws_seoul_eip[each.value.associate_public_ip_address].eip_id
  security_groups             = length(each.value.security_groups) > 0 ? [for sg_name in each.value.security_groups : module.aws_seoul_sg[sg_name].security_group_id] : null
  spot_options                = try(each.value.spot_options, null)
  root_ebs                    = each.value.root_ebs
  add_ebs                     = each.value.add_ebs
  disable_api_termination     = each.value.disable_api_termination
  iam_instance_profile        = try(each.value.iam_instance_profile, "")

  tags                        = local.project_map_tag  
  # depends_on = [ module.aws_seoul_eip ] # 절대 켜지말기.
}
