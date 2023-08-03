# HCTA Section 8 -- Read, generate, and modify configuration

## Exam objectives


Section | Description |
------- | ----------- |  
**8** | **Read, generate, and modify configuration***
8a | Demonstrate use of variables and outputs
8b | Describe secure secret injection best practice
8c | Understand the use of collection and structural types
8d | Create and differentiate resource and data configuration
8e | Use resource addressing and resource parameters to connect resources together
8f | Use HCL and Terraform functions to write configuration
8g | Describe built-in dependency management (order of execution based)


---  

## 8a	- Demonstrate use of variables and outputs

### Input Variables  

Documentation:  
https://developer.hashicorp.com/terraform/language/values/variables  

Declaring an input variable using the `variable` block 

`variables.tf` file:
```hcl
variable "some_var" {
  description = "Some description"
  type        = string             ### can be: string, number, bool, list()... etc.                
  default     = "value-by-default" ### assign a default value
  sensitive   = true               ### hides its value in the plan or apply output
  nullable    = true               ### whether variable can be null
}

variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}

variable "docker_ports" {
  type = list(object({
    internal = number
    external = number
    protocol = string
  }))
  default = [
    {
      internal = 8300
      external = 8300
      protocol = "tcp"
    }
  ]
}
```

To reference that variable in your Terraform code:
```hcl
variable "region" {
  type        = string
  description = "The AWS region for the infrastructure"
  default     = "us-west-2"
}
variable "instance_type" {
  type        = string
  description = "The EC2 instance type"
  default     = "t2.micro"
}

resource "aws_instance" "example" {
  instance_type = var.instance_type   ########### <<<< here
  ami           = "ami-0c55b159cbfafe1f0"
  region        = var.region          ########### <<<< here
}
```


#### Type Constraints

To restrict the `type` of value that will be accepted as the value for a variable. If no type constraint is set then a value of any type is accepted.

*Note*: A type Constraint is optional but best practice.

https://developer.hashicorp.com/terraform/language/expressions/type-constraints

Main types supported:
- Primitive 
- Complex
  - Collection
  - Structural



#### Primitive types:
- `string = "hello"`
- `number =  123 | 6.28`
- `bool   = true | false`  

```hcl
variable "string_var" {
  description = "Azure resource group name"
  type        = string
  default     = "learnterraform"
}

variable "number_var" {
  type    = number
  default = 3
}

variable "bool_var" {
  type    = bool
  default = false
}
```

#### Complex types:
- Collection
- Structural

##### Collection Types  

Allows multiple values of ***one*** type to be grouped together as a single value. 

- `list(<TYPE>)`
- `set(<TYPE>)`
- `map(<TYPE>)`

```hcl
variable "list_var" {
  description = "ordered sequence of values"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "set_var" {
  description = "unordered collection of distinct values"
  type        = set(string)
  default     = ["item1", "item2", "item3"]
}

variable "map_var" {
  description = "ordered collection of distinct values"
  type        = map(string)
  default     = { Name = "my-instance" }
}
```

##### Structural Types  

Allows multiple values of ***several*** distinct types to be grouped together as a single value. 

- `tuple([<TYPE>, ...])`
- `object({<ATTR NAME> = <TYPE>, ... })`

```hcl
variable "tuple_var" {
  description = "fixed-length collection that can contain values of different data types"
  type        = tuple([string, number, bool])
  default     = ["a", 15, true]
}

variable "object_var" {
  description = "multiple key-value pairs, where each key is associated with a specific data type for its corresponding value"
  type        = object({ name = string, age = number })
  default     = { name = "John", age = 52 }
}
```

##### `any` Type

The keyword `any` may be used to indicate that any type is acceptable.  


### Custom Validation Rules

A `validation` block can define validation rules, usually in addition to type constraints.

```hcl
variable "another_var" {
  type    = string
  default = "Hello"

  validation {
    condition     = length(var.another_var)
    error_message = "The string must be more than 4 characters long"
  }
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
```

---  

### Outputs  

Documentation:  
https://developer.hashicorp.com/terraform/language/values/outputs  


Each output value exported by a module must be declared using an output block.  

Declaring an output value using the `output` block   

`outputs.tf` file:
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


*Note*: Outputs are only rendered when Terraform applies your plan. Running terraform plan will not render outputs.  


### Accessing Child Module Outputs

In a parent module, outputs of child modules are available in expressions as `module.<MODULE_NAME>.<OUTPUT_NAME>` (not the root module name).

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"
  name = var.vpc_name
}

output "vpc_name" {
  value = module.vpc.vpc_name     ### notice `vpc_name` is an output name 
}                                 ### from the `vpc` child module
                                  ### Don't use root module outputs for `aws_vpc`
```

---  

## 8b	- Describe secure secret injection best practice

It is recommended to avoid placing secrets in your Terraform config or state file wherever possible, and if placed there, you take steps to reduce and manage your risk. 

[HashiCorp Vault](https://www.vaultproject.io) can help in that regards. 

The [Terraform provider for Vault](https://registry.terraform.io/providers/hashicorp/vault/latest) allows Terraform to read from, write to, and configure HashiCorp Vault.


```hcl
provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  # address = "https://vault.example.net:8200"
}

resource "vault_generic_secret" "example" {
  path = "secret/foo"

  data_json = jsonencode(
    {
      "foo"   = "bar",
      "pizza" = "cheese"
    }
  )
}
```

Tutorial : Inject Secrets into Terraform Using the Vault Provider    
https://developer.hashicorp.com/terraform/tutorials/secrets/secrets-vault

---  

## 8c	- Understand the use of collection and structural types

---  

## 8d	- Create and differentiate resource and data configuration

---  

## 8e	- Use resource addressing and resource parameters to connect resources together

---  

## 8f	- Use HCL and Terraform functions to write configuration

---  

## 8g	- Describe built-in dependency management (order of execution based)

---  
