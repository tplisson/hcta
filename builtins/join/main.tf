terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "rid" {
  byte_length = 4
}

resource "random_string" "rstring" {
  length           = 8
  special          = false
}

# Create VPC #1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = join("-", ["terraform-${random_id.rid.hex}", var.project-name])
    Create-Date = "${timestamp()}"
    Env = var.project-name
  }
}

# Create VPC #2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.2.0.0/16"
  tags = {
    Name = join("-", ["terraform-${random_string.rstring.result}", var.project-name])
    Create-Date = "${timestamp()}"
    Env = var.project-name
  }
}
