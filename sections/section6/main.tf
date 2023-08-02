provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "section6" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "section6"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.section6.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "subnet1"
  }
}