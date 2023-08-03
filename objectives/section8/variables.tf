### Sample variables

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

### Referencing a variable

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

### Primitive Types

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


### Collection Types

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

### Structural Types


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

### Custom Validation Rules

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