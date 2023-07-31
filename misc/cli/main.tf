provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "cli" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "cli_test"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.cli.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "subnet1"
  }
}