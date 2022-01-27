data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

data "aws_kms_alias" "s3" {
  name = "alias/aws/s3"
}

resource "aws_resourcegroups_group" "resourcegroups_group" {
  name = "group-${local.name}"
  resource_query {
    query = <<-JSON
{
"ResourceTypeFilters": [
"AWS::AllSupported"
],
"TagFilters": [
{
"Key": "ResourceGroup",
"Values": ["${var.namespace}"]
}
]
}
JSON
  }
}

# S3 bucket for state
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "terraform-${local.name}"
  force_destroy = var.force_destroy_state
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = data.aws_kms_alias.s3.arn
      }
    }
  }
  tags = local.tags
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "tfstate-lock-${local.name}"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = local.tags
}
