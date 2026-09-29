module "network" {
  source = "./modules/network"
  name_prefix = var.name_prefix
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}
module "security" {
  source = "./modules/security"
  name_prefix = var.name_prefix
  vpc_id = module.network.vpc_id
  allowed_https_cidrs = var.allowed_https_cidrs
}
module "storage" {
  source = "./modules/storage"
  bucket_name = var.data_bucket_name
}
module "iam" {
  source = "./modules/iam"
  name_prefix = var.name_prefix
  data_bucket_arn = module.storage.bucket_arn
  aws_region = var.aws_region
}
module "compute" {
  source = "./modules/compute"
  name_prefix = var.name_prefix
  subnet_id = module.network.public_subnet_id
  security_group_id = module.security.web_sg_id
  instance_profile_name = module.iam.instance_profile_name
  instance_type = var.instance_type
  root_volume_gb = var.root_volume_gb
}
module "monitoring" {
  source = "./modules/monitoring"
  name_prefix = var.name_prefix
  instance_id = module.compute.instance_id
}
