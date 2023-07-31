# Terraform Workspaces

Documentation:
https://developer.hashicorp.com/terraform/cli/workspaces


Referencing the current workspace is useful for changing behavior based on the workspace. 


`main.tf` file:
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "blank" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "blank"
  }
}
```

Listing current workspaces
```console
terraform workspace list
```
```terraform
* default
```

Creating a new workspace
```console
terraform workspace new dev
```
```terraform
Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
```

```console
terraform workspace list
```
```terraform
  default
* dev
```

For local state, Terraform stores the workspace states in a directory called `terraform.tfstate.d`.
```console
.
└── terraform.tfstate.d
    └── dev
```


Using `${terraform.workspace}` interpolation sequence

```hcl
resource "aws_vpc" "workspaces" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${terraform.workspace}-workspaces"
  }
}
```

This will deploy a VPC with a tag name based on the current workspace.



```console
terraform apply --auto-approve
```
```terraform
[...]
aws_vpc.vpc1: Creating...
aws_vpc.vpc1: Creation complete after 3s [id=vpc-09e79c1878854bea9]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc1_name = [
  "dev-vpc1",
]
```

Switching to the default workspace
```console
terraform workspace select default
```
```terraform
Switched to workspace "default".
```

If we apply the same terraform plan, it will create a separate resource based on the `${terraform.workspace}` variable now set to default
```console
terraform apply --auto-approve
```
```terraform

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # aws_vpc.vpc1 will be created
  + resource "aws_vpc" "vpc1" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = (known after apply)
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "default-vpc1"
        }
      + tags_all                             = {
          + "Name" = "default-vpc1"
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + vpc1_name = [
      + "default-vpc1",
    ]
aws_vpc.vpc1: Creating...
aws_vpc.vpc1: Creation complete after 2s [id=vpc-0b94a69a10807da4e]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

vpc1_name = [
  "default-vpc1",
]
```


## Conditions

Here we are using a different AWS region based on the workspace

```hcl
provider "aws" {
  region = terraform.workspace == "default" ? "us-east-1" : "us-west-1"
}
```

Or spining up smaller cluster sizes
```hcl
resource "aws_instance" "example" {
  count = "${terraform.workspace == "default" ? 5 : 1}"

  # ... other arguments
}
```
