variable "name_prefix" { type=string }
variable "data_bucket_arn" { type=string }
variable "aws_region" { type=string }
data "aws_caller_identity" "current" {}
resource "aws_iam_role" "ec2" {
  name = "${var.name_prefix}-ec2-role"
  path = "/bdd-datalake/"
  assume_role_policy = jsonencode({Version="2012-10-17",Statement=[{Effect="Allow",Principal={Service="ec2.amazonaws.com"},Action="sts:AssumeRole"}]})
  tags = { Name = "${var.name_prefix}-ec2-role" }
  lifecycle { prevent_destroy = true }
}
resource "aws_iam_role_policy" "ec2" {
  name = "${var.name_prefix}-runtime"
  role = aws_iam_role.ec2.id
  policy = jsonencode({Version="2012-10-17",Statement=[
    {Effect="Allow",Action=["s3:ListBucket"],Resource=[var.data_bucket_arn]},
    {Effect="Allow",Action=["s3:GetObject","s3:PutObject","s3:AbortMultipartUpload"],Resource=["${var.data_bucket_arn}/*"]},
    {Effect="Allow",Action=["ssm:GetParameter","ssm:GetParameters","ssm:GetParametersByPath"],Resource=["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/mpb/*"]},
    {Effect="Allow",Action=["logs:CreateLogStream","logs:PutLogEvents","logs:DescribeLogStreams"],Resource=["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/mpb/*"]}
  ]})
}
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role=aws_iam_role.ec2.name
  policy_arn="arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ec2" {
  name="${var.name_prefix}-ec2-profile"
  path="/bdd-datalake/"
  role=aws_iam_role.ec2.name
  tags={ Name="${var.name_prefix}-ec2-profile" }
  lifecycle { prevent_destroy = true }
}
output "instance_profile_name" { value=aws_iam_instance_profile.ec2.name }
