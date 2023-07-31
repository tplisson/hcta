provider "aws" {
  region = "us-east-1"
}

# resource "aws_vpc" "this" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "this" {
#   vpc_id     = aws_vpc.this.id
#   cidr_block = "10.0.1.0/24"
# }


variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

resource "aws_s3_bucket" "example" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}