locals {
    aws_s3 = {
        # --------------------------------------------------------------------------
        seoul = {        
            mysqlbackup-dsdsd = {
                acl                         = "private"
                control_object_ownership    = true
                object_ownership            = "ObjectWriter"
                attach_policy               = true
                versioning                  = false 

                block_public_acls           = true
                ignore_public_acls          = true
                block_public_policy         = true # 이 옵션을 true로 하면 버킷정책을 넣거나 수정할 수 없습니다. 버킷 정책 작업이 완료되면 true로 변경합니다.
                restrict_public_buckets     = true

                lifecycle_rule              = [ 
                    {
                        id      = "Delete_object_15days"
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



module "aws_s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  for_each  = local.aws_s3.seoul   

  providers = {
    aws = aws.seoul
  }

  bucket                    = each.key
  acl                       = each.value.acl
  control_object_ownership  = each.value.control_object_ownership
  object_ownership          = each.value.object_ownership
  attach_policy             = each.value.attach_policy
  policy                    = each.value.attach_policy ? data.aws_iam_policy_document.s3_bucket_policy[each.key].json : null

  versioning = {
    enabled = each.value.versioning
  }

  lifecycle_rule            = each.value.lifecycle_rule

  block_public_acls       = each.value.block_public_acls
  ignore_public_acls      = each.value.ignore_public_acls
  block_public_policy     = each.value.block_public_policy
  restrict_public_buckets = each.value.restrict_public_buckets

    tags = { 
        "Usage" = each.key
    }
}




data "aws_iam_policy_document" "s3_bucket_policy" {
  ## s3 bucket public access policy
  # https://docs.aws.amazon.com/ko_kr/AmazonS3/latest/userguide/HostingWebsiteOnS3Setup.html#step4-add-bucket-policy-make-content-public
  for_each  = local.aws_s3.seoul 

    statement { 
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "arn:aws:s3:::${each.key}/*",
        ]
    }
    statement {
        sid       = "RestrictToTLSRequestsOnly"
        effect    = "Deny"
        actions   = ["s3:*"]
        resources = [
            "arn:aws:s3:::${each.key}/*",
        ]

        condition {
            test     = "Bool"
            variable = "aws:SecureTransport"
            values   = ["false"]
        }

        principals {
            type        = "*"
            identifiers = ["*"]
        }
    }


}

#----------------------------------------------------------------------------------
