locals {
    aws_ecr = { 
        asdasd-qa-notification = {}
    }
}




module "aws_ecr" {
    source      = "i-gitlab.co.com/common/aws/ecr"
    for_each    = local.aws_ecr
    providers = {
        aws = aws.seoul
    }
    ecr_name    = each.key
    tags        = merge(try(each.value.tags, {}), local.project_map_tag)    
}
