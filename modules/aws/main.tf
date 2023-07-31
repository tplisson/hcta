resource "random_string" "rstring" {
  length  = 16
  upper   = false
  special = false
}


module "my_s3_bucket" {
  source      = "./s3-module"
  bucket_name = join("-", ["my-tf-bucket", random_string.rstring.result])
  # bucket_name = concat("my-tf-test-bucket-",random_string.rstring.result)
  environment = "production"
}



# module "s3_bucket" {
#   source = "terraform-aws-modules/s3-bucket/aws"

#   bucket = join("-", ["my-tf-bucket", random_string.rstring.result])
#   acl    = "private"

#   control_object_ownership = true
#   object_ownership         = "ObjectWriter"

#   versioning = {
#     enabled = true
#   }
# }