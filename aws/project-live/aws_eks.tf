locals {
    aws_eks = {
        # --------------------------------------------------------------------------
        seoul = {
             sdfsds-live-seoul-eks-01 = {
                 cluster_version      = "1.32"
                 public_access        = true
                 private_access       = true
                 public_access_cidrs  = [ "111.22.33.0/24", "222.333.44.0/24" ]

                 vpc                  = "vpc-fdfsfd-live"
                 control_plane_subnet = [ "private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1" ]
                 subnet_ids           = [ "private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1" ]
                 security_group       = [ "sdfsdf-live-eks-sg" ]

                 node_group = {
                    live-ingame-group = {
                         use_launch_template = true
                         node_subnet_ids     = [ "private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1" ]
                         launch_template     = "live-ingame-template"
                         min_size            = 5
                         max_size            = 5                           
                         desired_size        = 5                           # 실제 구성 내용
                         instance_types      = ["r7i.xlarge"]
                         disk_size           = 100                          # template 사용시 적용 안됨
                         capacity_type       = "ON_DEMAND"   
                         labels              = { 
                              "starseed/service" = "ingame"
                         }
                         create_iam_role     = false
                         iam_role_name       = "role_eks_node_basic"
                     }
                    live-battle-group = {
                         use_launch_template = true
                         node_subnet_ids     = [ "private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1" ]
                         launch_template     = "live-battle-template"
                         min_size            = 2
                         max_size            = 2                           
                         desired_size        = 2                           # 실제 구성 내용
                         instance_types      = ["m7i.large"]
                         disk_size           = 100                          # template 사용시 적용 안됨
                         capacity_type       = "ON_DEMAND"   
                         labels              = { 
                              "starseed/service" = "battle"
                         }
                         create_iam_role     = false
                         iam_role_name       = "role_eks_node_basic"
                     }           
                    live-merge-group = {
                         use_launch_template = true
                         node_subnet_ids     = [ "private-live-etc-subnet-a-1", "private-live-etc-subnet-b-1" ]
                         launch_template     = "live-merge-template"
                         min_size            = 2
                         max_size            = 2                           
                         desired_size        = 2                           # 실제 구성 내용
                         instance_types      = ["m7i.large"]
                         disk_size           = 100                          # template 사용시 적용 안됨
                         capacity_type       = "ON_DEMAND"   
                         labels              = { 
                              "starseed/service" = "merge"
                         }
                         create_iam_role     = false
                         iam_role_name       = "role_eks_node_basic"
                    }                      
                    live-monitoring-group = {
                         use_launch_template = true
                         node_subnet_ids     = [ "private-live-etc-subnet-a-1" ]
                         launch_template     = "live-monitoring-template"
                         min_size            = 1
                         max_size            = 1                           
                         desired_size        = 1                           # 실제 구성 내용
                         instance_types      = ["t3.large"]
                         disk_size           = 50                          # template 사용시 적용 안됨
                         capacity_type       = "ON_DEMAND"   
                         labels              = {
                            "kubelet.kubernetes.io/component" = "monitoring"
                         }
                         create_iam_role     = false
                         iam_role_name       = "role_eks_node_basic"
                     }                                                                                                                                                                                                                     
                 }
                cluster_addons = {
                   coredns = {
                       most_recent     = true
                       addon_version   = "v1.11.4-eksbuild.10"
                   }
                   kube-proxy = {
                       most_recent     = true
                       addon_version   = "v1.32.3-eksbuild.7"
                   }
                   vpc-cni = {
                       most_recent     = true
                       addon_version   = "v1.19.5-eksbuild.1"
                   }
                   aws-ebs-csi-driver = {
                       most_recent     = true
                       addon_version   = "v1.42.0-eksbuild.1"
                   }  
                   amazon-cloudwatch-observability = {
                       most_recent     = true
                       addon_version   = "v4.0.1-eksbuild.1"
                   }   
                }
                 tags = { 
                     "AWS.SSM.AppManager.EKS.Cluster.ARN" = "arn:aws:eks:ap-northeast-2:445645645:cluster/sdfsdfsd-live-seoul-eks-01"
                 }

                 encryption_kmy = false

             }

        }

    }
}



module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "v19.20.0"
    for_each  = local.aws_eks.seoul

    providers = {
        aws = aws.seoul
    }
    # manage_aws_auth_configmap = true

    cluster_name    = each.key
    cluster_version = each.value.cluster_version

    cluster_endpoint_public_access        = each.value.public_access
    cluster_endpoint_private_access       = each.value.private_access
    cluster_endpoint_public_access_cidrs  = each.value.public_access_cidrs

    cluster_addons = each.value.cluster_addons

    cluster_additional_security_group_ids = [for sg_name in each.value.security_group : module.aws_seoul_sg[sg_name].security_group_id]

    vpc_id                   = module.aws_seoul_vpc[each.value.vpc].vpc_id
    control_plane_subnet_ids = [for sub in each.value.control_plane_subnet : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]
    subnet_ids               = [for sub in each.value.subnet_ids : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]

    eks_managed_node_groups = {
        for group_key, group_value in each.value.node_group : 
        group_key => {  
            create_launch_template      = false
            subnet_ids                  = [for sub in group_value.node_subnet_ids : module.aws_seoul_vpc[each.value.vpc].subnets[sub].id]
            use_custom_launch_template  = group_value.use_launch_template
            launch_template_name        = group_value.use_launch_template != false ? group_value.launch_template : null
            launch_template_id          = group_value.use_launch_template != false ? module.aws_seoul_launch_template[group_value.launch_template].launch_template_id : null # group_value.use_custom_launch_template == "false" ? null : module.aws_seoul_lunch_template[group_value.launch_template].launch_template_id 
            launch_template_version     = group_value.use_launch_template != false ? module.aws_seoul_launch_template[group_value.launch_template].launch_template_latest_version : null 
            min_size                    = group_value.min_size
            max_size                    = group_value.max_size
            desired_size                = group_value.desired_size
            instance_types              = group_value.instance_types
            disk_size                   = group_value.disk_size
            capacity_type               = group_value.capacity_type
            labels                      = group_value.labels

            create_iam_role             = group_value.create_iam_role
            iam_role_name               = group_value.iam_role_name
            iam_role_arn                = group_value.iam_role_name == null ? null : module.aws_iam_role[group_value.iam_role_name].role_arn

            # use_name_prefix           = false                                     # false하지 않으면 리소스 이름 뒤 임의의 난수값이 추가되어 생성됨
        }
    }

    enable_kms_key_rotation     = false
    create_kms_key              = each.value.encryption_kmy
    cluster_encryption_config   = {}
    cluster_tags = merge(
        {
            for key, value in each.value.tags : key => value
        }
    )

    create_cluster_security_group = false
    create_node_security_group    = false
    cloudwatch_log_group_retention_in_days = 14
}




output "eks_managed_node_groups_autoscaling_group_names" {
  value = {
    for group_key, _ in local.aws_eks.seoul : group_key => module.eks[group_key].eks_managed_node_groups_autoscaling_group_names
  }
}

#--------------------------------------------------------------------------------------------
