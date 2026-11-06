variable "name_prefix" { type = string }
variable "vpc_cidr" { type = string }
variable "public_subnet_cidr" { type = string }
data "aws_availability_zones" "available" { state = "available" }
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.name_prefix}-vpc" }
  lifecycle { prevent_destroy = true }
}
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.name_prefix}-igw" }
  lifecycle { prevent_destroy = true }
}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.name_prefix}-public-a" }
  lifecycle { prevent_destroy = true }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = { Name = "${var.name_prefix}-public-rt" }
  lifecycle { prevent_destroy = true }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_id" { value = aws_subnet.public.id }
