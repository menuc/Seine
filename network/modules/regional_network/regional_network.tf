# Inputs
variable "project" {
  type        = "string"
  description = "Project name"
}

variable "vpc_cidr" {
  type        = "string"
  description = "CIDR block to be assigned to VPC"
}

# Outputs
output "vpc" {
  value = aws_vpc.default
}

output "subnet" {
  value = aws_subnet.default
}

output "route_table" {
  value = aws_route_table.default
}

# VPC
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = {
    project = "${var.project}"
  }
}

# Subnet
resource "aws_subnet" "default" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${aws_vpc.default.cidr_block}"
  map_public_ip_on_launch = true

  tags = {
    project = "${var.project}"
  }
}

# Route table
resource "aws_route_table" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    project = "${var.project}"
  }
}

# Route table association
resource "aws_route_table_association" "default" {
  subnet_id      = "${aws_subnet.default.id}"
  route_table_id = "${aws_route_table.default.id}"
}

# Internet gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    project = "${var.project}"
  }
}

# Internet route
resource "aws_route" "internet" {
  route_table_id         = "${aws_route_table.default.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}
