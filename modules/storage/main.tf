variable "bucket_name" { type = string }
variable "backup_retention_days" { type = number }
resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name
  tags   = { Name = var.bucket_name }
  lifecycle { prevent_destroy = true }
}
resource "aws_s3_bucket_versioning" "data" {
  bucket = aws_s3_bucket.data.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket = aws_s3_bucket.data.id
  rule {
    id     = "abort-incomplete-multipart"
    status = "Enabled"
    filter {}
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
  dynamic "rule" {
    for_each = ["backups/postgresql/", "backups/ckan/"]
    content {
      id     = "expire-${replace(trimsuffix(rule.value, "/"), "/", "-")}"
      status = "Enabled"
      filter {
        prefix = rule.value
      }
      expiration {
        days = var.backup_retention_days
      }
      noncurrent_version_expiration {
        noncurrent_days = 1
      }
    }
  }
}
output "bucket_arn" { value = aws_s3_bucket.data.arn }
output "bucket_name" { value = aws_s3_bucket.data.bucket }
