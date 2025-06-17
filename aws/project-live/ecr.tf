locals {
    aws_ecr = { 
        starseed-live-notification = {}

    aws_tokyo_ecr = { 
        starseedgb-live-analytics-scheduler = {}
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

module "aws_tokyo_ecr" {
    source      = "i-gitlab.co.com/common/aws/ecr"
    for_each    = local.aws_tokyo_ecr
    providers = {
        aws = aws.tokyo
    }
    ecr_name    = each.key
    tags        = merge(try(each.value.tags, {}), local.project_map_tag)   
}


