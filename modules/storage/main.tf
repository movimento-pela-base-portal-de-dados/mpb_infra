variable "bucket_name" { type=string }
resource "aws_s3_bucket" "data" {
  bucket = var.bucket_name
  tags = { Name = var.bucket_name }
  lifecycle { prevent_destroy = true }
}
resource "aws_s3_bucket_versioning" "data" { bucket=aws_s3_bucket.data.id; versioning_configuration { status="Enabled" } }
resource "aws_s3_bucket_server_side_encryption_configuration" "data" {
  bucket=aws_s3_bucket.data.id
  rule { apply_server_side_encryption_by_default { sse_algorithm="AES256" } }
}
resource "aws_s3_bucket_public_access_block" "data" {
  bucket=aws_s3_bucket.data.id
  block_public_acls=true; ignore_public_acls=true; block_public_policy=true; restrict_public_buckets=true
}
resource "aws_s3_bucket_lifecycle_configuration" "data" {
  bucket=aws_s3_bucket.data.id
  rule { id="abort-incomplete-multipart"; status="Enabled"; abort_incomplete_multipart_upload { days_after_initiation=7 } }
}
output "bucket_arn" { value=aws_s3_bucket.data.arn }
output "bucket_name" { value=aws_s3_bucket.data.bucket }
