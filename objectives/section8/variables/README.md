# Terraform Input Variables

Documentation:
https://developer.hashicorp.com/terraform/language/values/variables


## Basics

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
  instance_type = var.instance_type ### <<<< here
  ami           = "ami-0c55b159cbfafe1f0"
  region        = var.region ### <<<< here
}
```
  

### Variable Definitions (`.tfvars`) Files

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either `.tfvars` or `.tfvars.json`) and then specify that file on the command line with `-var-file`:

```console
terraform apply -var-file="testing.tfvars"
```

A variable definitions file uses the same basic syntax as Terraform language files, but consists only of variable name assignments:

`testing.tfvars`
```hcl
image_id = "ami-abc123"
availability_zone_names = [
  "us-east-1a",
  "us-west-1c",
]
```


### Environment Variables

As a fallback for the other ways of defining variables, Terraform searches the environment of its own process for environment variables named `TF_VAR_` followed by the name of a declared variable.

This can be useful when running Terraform in automation, or when running a sequence of Terraform commands in succession with the same variables. For example, at a bash prompt on a Unix system:

```zsh
export TF_VAR_image_id=ami-abc123
export TF_VAR_availability_zone_names='["us-west-1b","us-west-1d"]'
terraform plan
...
```

```console
export TF_VAR_image_id=ami-abc123
export TF_VAR_availability_zone_names='["us-west-1b","us-west-1d"]'
terraform plan
...
```


### Type Constraints

To restrict the `type` of value that will be accepted as the value for a variable. This is optional but best practice.

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

allows multiple values of ***one*** other type to be grouped together as a single value. 

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

variable "instance_tags" {
  description = "ordered collection of distinct values"
  type        = map(string)
  default     = { Name = "my-instance" }
}
```

##### Structural Types  

allows multiple values of ***several*** distinct types to be grouped together as a single value. 

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


The keyword any may be used to indicate t

### Custom Validation Rules

validation - A block to define validation rules, usually in addition to type constraints.

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


### Type Constraints
https://developer.hashicorp.com/terraform/language/expressions/type-constraints

