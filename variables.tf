variable "aws_region" {
  description = "Região AWS padrão do projeto. Alterações devem ser tratadas como decisão arquitetural."
  type        = string
  default     = "sa-east-1"
}
variable "environment" {
  type    = string
  default = "production"
}
variable "name_prefix" {
  type    = string
  default = "mpb-portal"
}
variable "vpc_cidr" {
  type    = string
  default = "10.40.0.0/16"
}
variable "public_subnet_cidr" {
  type    = string
  default = "10.40.10.0/24"
}
variable "instance_type" {
  type    = string
  default = "t3.medium"
}
variable "root_volume_gb" {
  type    = number
  default = 100
}
variable "instance_profile_name" {
  description = "Instance profile existente na conta. O grupo de engenharia não cria roles."
  type        = string
  default     = "movimento-pela-base-profile"
}
variable "data_bucket_name" { type = string }
variable "allowed_https_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
variable "ckan_domain" {
  description = "Domínio público do portal, sem protocolo."
  type        = string
}
variable "ckan_repository" {
  type    = string
  default = "https://github.com/movimento-pela-base-portal-de-dados/mpb_ckan.git"
}
variable "compose_version" {
  type    = string
  default = "v5.6.1"
}
variable "buildx_version" {
  type    = string
  default = "v0.38.1"
}
variable "ckan_parameters" {
  description = "Valores não secretos do .env de produção do CKAN, gravados em /mpb/ckan/<CHAVE>."
  type        = map(string)
  default = {
    NGINX_PORT_HOST    = "80"
    NGINX_SSLPORT_HOST = "443"
  }
}
variable "ckan_secret_parameters" {
  description = "Chaves secretas do .env de produção do CKAN. O Terraform cria o parâmetro; o valor é gravado pela operação."
  type        = set(string)
  default = [
    "POSTGRES_PASSWORD",
    "CKAN_DB_PASSWORD",
    "DATASTORE_READONLY_PASSWORD",
    "CKAN_SQLALCHEMY_URL",
    "CKAN_DATASTORE_WRITE_URL",
    "CKAN_DATASTORE_READ_URL",
    "CKAN___BEAKER__SESSION__SECRET",
    "CKAN___API_TOKEN__JWT__ENCODE__SECRET",
    "CKAN___API_TOKEN__JWT__DECODE__SECRET",
    "CKAN_SYSADMIN_PASSWORD",
    "CKAN__DATAPUSHER__API_TOKEN",
  ]
}
variable "backup_retention_days" {
  type    = number
  default = 30
}
variable "log_retention_days" {
  type    = number
  default = 14
}
variable "usage_alarm_threshold" {
  description = "Percentual de CPU, memória e disco que dispara alarme."
  type        = number
  default     = 80
}
variable "backup_alarm_hours" {
  description = "Horas sem backup concluído até o alarme."
  type        = number
  default     = 26
}
