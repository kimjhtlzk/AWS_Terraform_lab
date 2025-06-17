resource "aws_s3_bucket" "this" {
  bucket                      = var.bucket_name
  force_destroy               = false
  object_lock_enabled         = false
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }

  depends_on = [
    aws_s3_bucket_policy.this,
    aws_s3_bucket_public_access_block.this,
    aws_s3_bucket.this
  ]
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rule

    content {
      id     = rule.value.id
      status = rule.value.enabled ? "Enabled" : "Disabled"

      abort_incomplete_multipart_upload {
        days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
      }

      expiration {
        days                         = rule.value.expiration.days
        expired_object_delete_marker = rule.value.expiration.expired_object_delete_marker
      }

      noncurrent_version_expiration {
        noncurrent_days = rule.value.noncurrent_version_expiration.days
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    mfa_delete = "Disabled"
    status     = "Suspended"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket  = aws_s3_bucket.this.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

data "aws_iam_policy_document" "s3_bucket_policy" {
    statement { 
        principals {
            type        = "AWS"
            identifiers = ["*"]
        }
        actions = [
            "s3:GetObject"
        ]
        resources = [
            "arn:aws:s3:::${var.bucket_name}/*",
        ]
    }
    statement {
        sid       = "RestrictToTLSRequestsOnly"
        effect    = "Deny"
        actions   = ["s3:*"]
        resources = [
            "arn:aws:s3:::${var.bucket_name}/*",
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

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}