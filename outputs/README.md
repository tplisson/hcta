# Terraform Output Values

Documentation:
https://developer.hashicorp.com/terraform/language/values/variables


## Basics

Each output value exported by a module must be declared using an output block:


Declaring an output value using the `output` block 

`output.tf` file:
```hcl
output "instance_ip_addr" {
  value = aws_instance.server.private_ip
}
```

Note: Outputs are only rendered when Terraform applies your plan. Running terraform plan will not render outputs.


### Accessing Child Module Outputs

In a parent module, outputs of child modules are available in expressions as `module.<MODULE NAME>.<OUTPUT NAME>`. 

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = var.vpc_name
}

output "vpc_name" {
  value = module.vpc.vpc_name
}
```