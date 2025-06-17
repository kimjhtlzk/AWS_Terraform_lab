
locals {
    aws_launch_template = {
        # --------------------------------------------------------------------------
        seoul = {
            live-ingame-template = {
                marked_to_ec2_name  = "live-ingame-group"
                instance_type       = null  # eks 노드그룹용 탬플릿일 경우에는 null로 지정해야한다.
                ebs_optimized       = true
                image_id            = null  
                availability_zone   = null
                http_put_response_hop_limit = 2                
                block_device_mappings = {
                    1 = {
                        device_name = "/dev/xvda"
                        volume_size = "100"
                        volume_type = "gp3"
                    }
                }
            }
        }
    }
}



module "aws_seoul_launch_template" {
    source      = "i-gitlab.co.com/common/aws/launchtemplate"
    version     = "1.0.0"

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
    http_put_response_hop_limit = try(each.value.http_put_response_hop_limit, null)
    #http_tokens                 = try(each.value.http_tokens, "optional")
}
