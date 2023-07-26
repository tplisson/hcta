provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "import" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "new_vpc_created_from_aws_ui"
  }
}