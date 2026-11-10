module "network" {
  source             = "./modules/network"
  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}
module "security" {
  source              = "./modules/security"
  name_prefix         = var.name_prefix
  vpc_id              = module.network.vpc_id
  allowed_https_cidrs = var.allowed_https_cidrs
}
module "storage" {
  source                = "./modules/storage"
  bucket_name           = var.data_bucket_name
  backup_retention_days = var.backup_retention_days
}
module "iam" {
  source                = "./modules/iam"
  instance_profile_name = var.instance_profile_name
}
module "compute" {
  source                = "./modules/compute"
  name_prefix           = var.name_prefix
  subnet_id             = module.network.public_subnet_id
  security_group_id     = module.security.web_sg_id
  instance_profile_name = module.iam.instance_profile_name
  instance_type         = var.instance_type
  root_volume_gb        = var.root_volume_gb
  ckan_repository       = var.ckan_repository
  compose_version       = var.compose_version
  buildx_version        = var.buildx_version
}
module "ckan_parameters" {
  source = "./modules/parameters"
  prefix = "/mpb/ckan"
  values = merge(var.ckan_parameters, {
    CKAN_DOMAIN     = var.ckan_domain
    CKAN_SITE_URL   = "https://${var.ckan_domain}"
    MPB_DATA_BUCKET = module.storage.bucket_name
  })
  secret_names = var.ckan_secret_parameters
}
module "monitoring" {
  source                = "./modules/monitoring"
  name_prefix           = var.name_prefix
  instance_id           = module.compute.instance_id
  log_retention_days    = var.log_retention_days
  usage_alarm_threshold = var.usage_alarm_threshold
  backup_alarm_hours    = var.backup_alarm_hours
}
