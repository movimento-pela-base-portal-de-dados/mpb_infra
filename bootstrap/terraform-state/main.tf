terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0, < 7.0" }
  }
}
variable "aws_region" {
  type    = string
  default = "sa-east-1"
}
variable "state_bucket_name" { type = string }
provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "mpb"
      ManagedBy = "Terraform"
      System    = "MPB_Portal_Dados"
    }
  }
}
resource "aws_s3_bucket" "state" {
  bucket = var.state_bucket_name
  tags   = { Name = var.state_bucket_name }
  lifecycle { prevent_destroy = true }
}
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
output "state_bucket" { value = aws_s3_bucket.state.bucket }
