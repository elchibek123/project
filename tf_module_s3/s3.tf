resource "aws_s3_bucket" "ak3-bucket" {
  bucket = "${var.product-name}-${var.environment}-ue1-s3-00${var.resource-number}"
  acl    = "private"
  versioning {
    enabled = true
  }
  #server_side_encryption_configuration {
  #  rule {
  #    apply_server_side_encryption_by_default {
  #      kms_master_key_id = data.aws_kms_key.ak3-key-id.key_id
  #      sse_algorithm     = "aws:kms"
  #    }
  #  }
  #}
  tags = merge(
    local.common_tags,
    {
      "Name" = "${var.product-name}-${var.environment}-ue1-s3-00${var.resource-number}"
    }
  )
}

# Bucket Policy

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.ak3-bucket.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["aws_account_number", "aws_account_number"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.ak3-bucket.arn,
      "${aws_s3_bucket.ak3-bucket.arn}/*",
    ]
  }
}