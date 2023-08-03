output "name" {
  description = "random string to be used as unique bucket name"
  value       = random_string.rstring
}


output "my_s3_bucket" {
  description = "S3 bucket name"
  value       = module.my_s3_bucket.bucket_name
  # value       = module.my_s3_bucket.bucket_name.aws_s3_bucket.example
}
