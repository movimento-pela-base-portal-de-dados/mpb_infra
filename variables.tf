variable "aws_region" {
  description = "Região AWS padrão do projeto. Alterações devem ser tratadas como decisão arquitetural."
  type        = string
  default     = "sa-east-1"
}
variable "environment" { type = string; default = "production" }
variable "name_prefix" { type = string; default = "mpb-portal" }
variable "vpc_cidr" { type = string; default = "10.40.0.0/16" }
variable "public_subnet_cidr" { type = string; default = "10.40.10.0/24" }
variable "instance_type" { type = string; default = "t3.medium" }
variable "root_volume_gb" { type = number; default = 100 }
variable "data_bucket_name" { type = string }
variable "allowed_https_cidrs" { type = list(string); default = ["0.0.0.0/0"] }
