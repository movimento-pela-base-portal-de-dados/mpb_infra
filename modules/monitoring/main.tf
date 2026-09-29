variable "name_prefix" { type=string }
variable "instance_id" { type=string }
resource "aws_cloudwatch_log_group" "mpb" {
  name="/mpb/${var.name_prefix}"
  retention_in_days=14
  tags={ Name="${var.name_prefix}-logs" }
  lifecycle { prevent_destroy = true }
}
resource "aws_cloudwatch_metric_alarm" "status" {
  alarm_name="${var.name_prefix}-instance-status"
  comparison_operator="GreaterThanOrEqualToThreshold"
  evaluation_periods=2
  metric_name="StatusCheckFailed"
  namespace="AWS/EC2"
  period=60
  statistic="Maximum"
  threshold=1
  alarm_description="Falha de status da EC2 do portal MPB"
  dimensions={ InstanceId=var.instance_id }
  tags={ Name="${var.name_prefix}-instance-status" }
}
