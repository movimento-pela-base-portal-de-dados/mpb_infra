variable "prefix" { type = string }
variable "values" { type = map(string) }
variable "secret_names" { type = set(string) }
resource "aws_ssm_parameter" "value" {
  for_each = var.values
  name     = "${var.prefix}/${each.key}"
  type     = "String"
  value    = each.value
}
resource "aws_ssm_parameter" "secret" {
  for_each = var.secret_names
  name     = "${var.prefix}/${each.key}"
  type     = "SecureString"
  value    = "CHANGE_ME"
  lifecycle { ignore_changes = [value] }
}
