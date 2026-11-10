variable "name_prefix" { type = string }
variable "instance_id" { type = string }
variable "log_retention_days" { type = number }
variable "usage_alarm_threshold" { type = number }
variable "backup_alarm_hours" { type = number }
resource "aws_cloudwatch_log_group" "ckan" {
  for_each          = toset(["nginx", "ckan"])
  name              = "/mpb/ckan/${each.key}"
  retention_in_days = var.log_retention_days
  tags              = { Name = "${var.name_prefix}-${each.key}-logs" }
  lifecycle { prevent_destroy = true }
}
resource "aws_cloudwatch_metric_alarm" "status" {
  alarm_name          = "${var.name_prefix}-instance-status"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 1
  alarm_description   = "Falha de status da EC2 do portal MPB"
  dimensions          = { InstanceId = var.instance_id }
  tags                = { Name = "${var.name_prefix}-instance-status" }
}
resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${var.name_prefix}-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.usage_alarm_threshold
  alarm_description   = "CPU da EC2 do portal MPB acima do limite"
  dimensions          = { InstanceId = var.instance_id }
  tags                = { Name = "${var.name_prefix}-cpu" }
}
resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name          = "${var.name_prefix}-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Average"
  threshold           = var.usage_alarm_threshold
  alarm_description   = "Memória da EC2 do portal MPB acima do limite"
  dimensions          = { InstanceId = var.instance_id }
  tags                = { Name = "${var.name_prefix}-memory" }
}
resource "aws_cloudwatch_metric_alarm" "disk" {
  alarm_name          = "${var.name_prefix}-disk"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = 300
  statistic           = "Maximum"
  threshold           = var.usage_alarm_threshold
  alarm_description   = "Disco da EC2 do portal MPB acima do limite"
  dimensions          = { InstanceId = var.instance_id, path = "/" }
  tags                = { Name = "${var.name_prefix}-disk" }
}
resource "aws_cloudwatch_metric_alarm" "backup" {
  alarm_name          = "${var.name_prefix}-backup"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.backup_alarm_hours
  datapoints_to_alarm = var.backup_alarm_hours
  metric_name         = "BackupSuccess"
  namespace           = "MPB"
  period              = 3600
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"
  alarm_description   = "Nenhum backup do portal MPB concluído no período"
  tags                = { Name = "${var.name_prefix}-backup" }
}
