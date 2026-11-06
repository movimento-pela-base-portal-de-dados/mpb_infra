variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "allowed_https_cidrs" { type = list(string) }
resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-web-sg"
  description = "HTTPS publico; sem SSH, PostgreSQL, Redis ou Solr publicos"
  vpc_id      = var.vpc_id
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_https_cidrs
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "${var.name_prefix}-web-sg" }
  lifecycle { prevent_destroy = true }
}
output "web_sg_id" { value = aws_security_group.web.id }
