module "s3" {
  source = "./modules/s3"
}

output "Bucket-name" {
  description = "The name of S3 bucket"
  value       = module.s3.bucket-name
}