variable "instance_profile_name" { type = string }
data "aws_iam_instance_profile" "ec2" {
  name = var.instance_profile_name
}
output "instance_profile_name" { value = data.aws_iam_instance_profile.ec2.name }
output "role_name" { value = data.aws_iam_instance_profile.ec2.role_name }
