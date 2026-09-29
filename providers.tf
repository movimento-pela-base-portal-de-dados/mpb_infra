provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Project   = "Base_dos_Dados_Datalake"
      ManagedBy = "Terraform"
      System    = "MPB_Portal_Dados"
    }
  }
}
