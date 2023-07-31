## Terraform Modules

Documentation:
https://developer.hashicorp.com/terraform/language/modules

Terraform modules are reusable, self-contained units of infrastructure configuration that allow you to encapsulate and share your infrastructure code. They provide a way to organize your Terraform configuration into smaller, more manageable pieces, promoting modularity, and reusability. With modules, you can create consistent infrastructure patterns, simplify complex configurations, and foster collaboration across teams.

### Benefits of Terraform Modules:

1. **Reusability**: Modules enable you to abstract and package specific sets of resources, making them easily reusable across multiple projects.

2. **Simplicity**: By encapsulating resources and configurations in modules, you can simplify your main configuration, making it easier to read and maintain.

3. **Scalability**: Modules help you build scalable infrastructures by promoting consistent patterns and reducing redundancy in your Terraform code.

4. **Collaboration**: Modularizing your infrastructure encourages collaboration between teams by creating a shared library of infrastructure components.

5. **Versioning**: Modules can have versioning, allowing you to control and track changes over time.


### Sample Terraform Module for AWS:

Here's a simple example of a Terraform module for creating an AWS S3 bucket:

```hcl
# main.tf

variable "bucket_name" {
  type        = string
  description = "The name of the S3 bucket."
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# variables.tf

variable "environment" {
  type        = string
  description = "The environment in which the S3 bucket is deployed."
}
```

To use this module, you need to create a separate Terraform configuration file, e.g., `main.tf`, in your project:

```hcl
# main.tf

module "my_s3_bucket" {
  source      = "path/to/module"
  bucket_name = "my-unique-bucket-name"
  environment = "production"
}
```

By calling the `module` block, you can instantiate the module and pass values to its variables. This way, you create an S3 bucket with the specified name and tags without having to write the entire configuration again and again.

Remember to replace `"path/to/module"` with the actual path to your module. Additionally, ensure that you have valid AWS credentials configured to execute the Terraform code successfully.

By utilizing Terraform modules, you can build a library of infrastructure components that can be shared, versioned, and easily integrated into various projects, enhancing collaboration and maintainability in your infrastructure as code workflows.