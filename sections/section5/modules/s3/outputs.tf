output "bucket-name" {
  description = "The name of S3 bucket"
  value       = aws_s3_bucket.this.arn
}