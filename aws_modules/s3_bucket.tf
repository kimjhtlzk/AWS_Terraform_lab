locals {
    aws_s3 = {
        # --------------------------------------------------------------------------
        seoul = {
            ihanni-s3-bucket-01 = {
                acl                         = "private"
                # control_object_ownership    = true
                object_ownership            = "ObjectWriter"
                # attach_policy               = true
                versioning                  = false 

                block_public_acls           = true
                ignore_public_acls          = true
                block_public_policy         = false # 이 옵션을 true로 하면 버킷정책을 넣거나 수정할 수 없습니다. 버킷 정책 작업이 완료되면 true로 변경합니다.
                restrict_public_buckets     = true

                lifecycle_rule              = [ 
                    {
                        id      = "lifecycle-rules-root-path"
                        enabled = true
                        prefix  = "/"
                    
                        abort_incomplete_multipart_upload_days = 15
                        
                        expiration = {
                            days                         = 15
                            expired_object_delete_marker = false
                        }
                    
                        noncurrent_version_expiration = {
                            days = 1
                        }
                    },
                    {
                        id      = "lifecycle-rules-root-path2"
                        enabled = true
                        prefix  = "/"
                    
                        abort_incomplete_multipart_upload_days = 15
                        
                        expiration = {
                            days                         = 15
                            expired_object_delete_marker = false
                        }
                    
                        noncurrent_version_expiration = {
                            days = 1
                        }
                    },
                ]
            }



        }

    }
}

module "aws_seoul_s3_bucket" {
  source    = "i-gitlab.co.com/common/aws/s3"

  for_each  = local.aws_s3.seoul   

  providers = {
    aws = aws.seoul
  }

  bucket_name               = each.key
  acl                       = each.value.acl
  object_ownership          = each.value.object_ownership

  versioning                = each.value.versioning

  lifecycle_rule            = each.value.lifecycle_rule

  block_public_acls         = each.value.block_public_acls
  ignore_public_acls        = each.value.ignore_public_acls
  block_public_policy       = each.value.block_public_policy
  restrict_public_buckets   = each.value.restrict_public_buckets

  tags                      = merge(try(each.value.tags, {}), local.project_map_tag)
}



