# Terraform Output Values

Documentation:
https://developer.hashicorp.com/terraform/language/values/outputs

### Overview

Each output value exported by a module must be declared using an output block.

Declaring an output value using the `output` block 

`output.tf` file:
```hcl
output "vpc_name" {
  value = aws_vpc.outputs.tags[*].Name
}

output "vpc_arn" {
  value = aws_vpc.outputs.arn
}

output "vpc_id" {
  value = aws_vpc.outputs.id
}

output "vpc_cidr_block" {
  value = aws_vpc.outputs.cidr_block
}
```

```console
terraform apply --auto-approve
```
```terraform
aws_vpc.outputs: Refreshing state... [id=vpc-06d76c5cc08006047]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vpc_arn = "arn:aws:ec2:us-east-1:431229157735:vpc/vpc-06d76c5cc08006047"
vpc_cidr_block = "10.0.0.0/16"
vpc_id = "vpc-06d76c5cc08006047"
vpc_name = [
  "outputs",
]
```


```hcl
output "vpc" {
  value = aws_vpc.outputs
}
```
```console
terraform apply --auto-approve
```
```terraform
aws_vpc.outputs: Refreshing state... [id=vpc-06d76c5cc08006047]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

vpc = {
  "arn" = "arn:aws:ec2:us-east-1:431229157735:vpc/vpc-06d76c5cc08006047"
  "assign_generated_ipv6_cidr_block" = false
  "cidr_block" = "10.0.0.0/16"
  "default_network_acl_id" = "acl-0f784fe7e8fbf030f"
  "default_route_table_id" = "rtb-075f0ee90db40bca1"
  "default_security_group_id" = "sg-06180df19869ccbad"
  "dhcp_options_id" = "dopt-0b65008a22c1c7a87"
  "enable_dns_hostnames" = false
  "enable_dns_support" = true
  "enable_network_address_usage_metrics" = false
  "id" = "vpc-06d76c5cc08006047"
  "instance_tenancy" = "default"
  "ipv4_ipam_pool_id" = tostring(null)
  "ipv4_netmask_length" = tonumber(null)
  "ipv6_association_id" = ""
  "ipv6_cidr_block" = ""
  "ipv6_cidr_block_network_border_group" = ""
  "ipv6_ipam_pool_id" = ""
  "ipv6_netmask_length" = 0
  "main_route_table_id" = "rtb-075f0ee90db40bca1"
  "owner_id" = "431229157735"
  "tags" = tomap({
    "Name" = "outputs"
  })
  "tags_all" = tomap({
    "Name" = "outputs"
  })
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