terraform {
  backend "s3" {
    bucket       = "mpb-terraform-state-prod"
    key          = "mpb-infra/production/terraform.tfstate"
    region       = "sa-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
