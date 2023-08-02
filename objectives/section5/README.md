# HCTA Section 5 - Interact with Terraform modules

## Exam objectives

Section | Description |
------- | ----------- |  
**5**	| **Interact with Terraform modules**
5a | Contrast and use different module source options including the public Terraform Module Registry
5b | Interact with module inputs and outputs
5c | Describe variable scope within modules/child modules
5d | Set module version

---  

## 5a	- Contrast and use different module source options including the public Terraform Module Registry

The syntax for specifying a registry module is `<NAMESPACE>/<NAME>/<PROVIDER>`. 
For example: `hashicorp/consul/aws`

You can also use modules from a *private* registry, like the one provided by Terraform Cloud. 
Private registry modules have source strings of the form `<HOSTNAME>/<NAMESPACE>/<NAME>/<PROVIDER>`. So same format but prepended by a hostname prefix.


`main.tf`  
```hcl
provider "aws" {
  region = "us-west-2"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"  #### Module called here
  version = "3.18.1"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway

  tags = var.vpc_tags
}
```

---  

## 5b - Interact with module inputs and outputs

### Inputs  

When you declare variables in the root module of your configuration, you can set their values using CLI options and environment variables. 

When you declare them in child modules, the calling module should pass values in the `module` block.

### Outputs  

Accessing Module Output Values using `module.<module_name>.resource`

```hcl
resource "aws_elb" "example" {
  # ...

  instances = module.servers.instance_ids
}
```  

---  

## 5c - Describe variable scope within modules/child modules

```
├── main.tf
└── modules
    └── s3
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

`main.tf`
```hcl {title="main.tf"}
module "s3" {
  source = "./modules/s3"
}

output "bucket-name" {
  description = "The name of S3 bucket"
  value       = module.s3.bucket-name
}
```

```console
terraform apply
```
```terraform
...
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

bucket-name = "arn:aws:s3:::private-bucket-p790wabw80"
```

---  

## 5d - Set module version

It is recommended to explicitly constraining the acceptable version numbers to avoid unexpected or unwanted changes.

`main.tf`  
```terraform filename="main.tf"
provider "aws" {
  region = "us-west-2"
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" 
  version = "3.18.1"                         #### Module version set here
  ...
}
```
---  
