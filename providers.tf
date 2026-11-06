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
