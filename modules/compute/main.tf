variable "name_prefix" { type=string }
variable "subnet_id" { type=string }
variable "security_group_id" { type=string }
variable "instance_profile_name" { type=string }
variable "instance_type" { type=string }
variable "root_volume_gb" { type=number }
data "aws_ssm_parameter" "al2023" { name="/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" }
resource "aws_instance" "ckan" {
  ami = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  iam_instance_profile = var.instance_profile_name
  associate_public_ip_address = true
  metadata_options { http_endpoint="enabled"; http_tokens="required" }
  root_block_device { volume_type="gp3"; volume_size=var.root_volume_gb; encrypted=true; delete_on_termination=false; tags={ Name="${var.name_prefix}-root", Project="Base_dos_Dados_Datalake" } }
  user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail
    dnf update -y
    dnf install -y docker git amazon-cloudwatch-agent
    systemctl enable --now docker
    usermod -aG docker ec2-user
    mkdir -p /opt/mpb /var/lib/mpb/{postgresql,solr,ckan}
    chown -R ec2-user:ec2-user /opt/mpb /var/lib/mpb
  EOT
  tags = { Name="${var.name_prefix}-ckan"; Environment="production" }
  lifecycle { prevent_destroy = true; ignore_changes=[ami] }
}
output "instance_id" { value=aws_instance.ckan.id }
output "public_ip" { value=aws_instance.ckan.public_ip }
