provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}


locals {
  security_groups = {
    group1 = ["192.168.1.0/24", "10.0.1.0/24"],
    group2 = ["172.16.1.0/24"]
  }
}

resource "aws_security_group" "example" {
  for_each = local.security_groups

  name_prefix = "dynamic-sg-"
  description = "Security group created dynamically."

  dynamic "ingress" {
    for_each = each.value
    content {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
}