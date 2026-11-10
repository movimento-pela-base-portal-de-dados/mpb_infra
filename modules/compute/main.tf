variable "name_prefix" { type = string }
variable "subnet_id" { type = string }
variable "security_group_id" { type = string }
variable "instance_profile_name" { type = string }
variable "instance_type" { type = string }
variable "root_volume_gb" { type = number }
variable "ckan_repository" { type = string }
variable "compose_version" { type = string }
variable "buildx_version" { type = string }
data "aws_ssm_parameter" "al2023" { name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" }
resource "aws_instance" "ckan" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.instance_profile_name
  associate_public_ip_address = true
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_gb
    encrypted             = true
    delete_on_termination = false
    tags                  = { Name = "${var.name_prefix}-root", Project = "mpb" }
  }
  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    ckan_repository = var.ckan_repository
    compose_version = var.compose_version
    buildx_version  = var.buildx_version
  })
  tags = { Name = "${var.name_prefix}-ckan", Environment = "production" }
  lifecycle {
    prevent_destroy = true
    ignore_changes  = [ami, user_data]
  }
}
resource "aws_eip" "ckan" {
  domain   = "vpc"
  instance = aws_instance.ckan.id
  tags     = { Name = "${var.name_prefix}-ckan" }
  lifecycle { prevent_destroy = true }
}
output "instance_id" { value = aws_instance.ckan.id }
output "public_ip" { value = aws_eip.ckan.public_ip }
