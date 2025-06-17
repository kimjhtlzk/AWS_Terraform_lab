
locals {
    aws_launch_template = {
        # --------------------------------------------------------------------------
        seoul = {
            ihanni-rnd-eks-template-01 = {
                marked_to_ec2_name  = "rnd-node-group-01"
                instance_type       = null  # eks 노드그룹용 탬플릿일 경우에는 null로 지정해야한다.
                ebs_optimized       = true
                image_id            = null  # eks 노드그룹용 탬플릿일 경우에는 image id 지정시 cluster 버전을 사용할 수 없다.                availability_zone   = "ap-northeast-2a"
                availability_zone   = null

                block_device_mappings = {
                    1 = {
                        device_name = "/dev/xvda"
                        volume_size = "30"
                        volume_type = "gp3"
                    }
                    2 = {
                        device_name = "/dev/xvdb"
                        volume_size = "40"
                        volume_type = "gp3"
                    }
                }
            }
            ihanni-rnd-eks-template-02 = {
                marked_to_ec2_name  = "rnd-node-group-02"
                instance_type       = "t3.medium"    # eks 노드그룹용 탬플릿일 경우에는 null로 지정해야한다.
                ebs_optimized       = true
                image_id            = "ami-1332413212"   # eks 노드그룹용 탬플릿일 경우에는 image id 지정시 cluster 버전을 사용할 수 없다.
                availability_zone   = "ap-northeast-2a"
                
                block_device_mappings = {
                    1 = {
                        device_name = "/dev/xvda"
                        volume_size = "50"
                        volume_type = "gp3"
                    }
                    2 = {
                        device_name = "/dev/xvdb"
                        volume_size = "60"
                        volume_type = "gp3"
                    }
                }
            }


        }
    }
}



module "aws_seoul_launch_template" {
    source      = "i-gitlab.co.com/common/aws/launchtemplate"
    for_each    = local.aws_launch_template.seoul

    providers = {
        aws = aws.seoul
    }

    launch_template_name        = each.key
    marked_to_ec2_name          = each.value.marked_to_ec2_name
    instance_type               = each.value.instance_type
    ebs_optimized               = each.value.ebs_optimized
    update_default_version      = try(each.value.update_default_version, true)
    image_id                    = each.value.image_id
    availability_zone           = each.value.availability_zone
    block_device_mappings       = each.value.block_device_mappings
    http_put_response_hop_limit = try(each.value.http_put_response_hop_limit, 2)
    http_tokens                 = try(each.value.http_tokens, "required")
}
