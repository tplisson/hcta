# Terraform Dynamic Blocks

Documentation:
https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks


Dynamic blocks in Terraform provide a powerful and flexible way to handle multiple nested configurations within a single resource or module block. 

## Syntax

The syntax for a dynamic block is as follows:

```hcl
dynamic "BLOCK_TYPE" {
  for_each = EXPRESSION
  content {
    # Nested block configuration
  }
}
```

- **BLOCK_TYPE**: Specifies the type of nested block being created. It can be any valid block type, such as `resource`, `variable`, or `provider`, among others.
- **for_each**: This argument is crucial for dynamic blocks. It takes an expression that evaluates to a map or a set, and Terraform will dynamically create a nested block for each element in the map or set.
- **content**: Inside the `content` block, you define the configuration for the nested block using the same syntax as if it were a regular static block.

## Usage

Dynamic blocks are particularly useful when you have a variable number of similar resources to create or when dealing with data from external sources like maps or sets. They enable concise and scalable configurations without the need for duplicating code.

Here is an example of creating multiple `aws_security_group` resources dynamically using a `for_each` loop:

```hcl
locals {
  security_groups = {
    group1 = ["192.168.1.0/24", "10.0.1.0/24"],
    group2 = ["172.16.1.0/24"]
  }
}

resource "aws_security_group" "example" {
  for_each = local.security_groups

  name_prefix = "dynamic-sg-"
  description = "Security group created dynamically."

  dynamic "ingress" {
    for_each = each.value
    content {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
}
```

In this example, the `for_each` loop iterates over the `local.security_groups` map, creating a separate `aws_security_group` resource for each entry. The `dynamic` block inside it then creates multiple `ingress` blocks for each CIDR block defined in the corresponding map value.

```console
terraform apply -auto-approve
```

```console
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the
following symbols:
  + create

Terraform will perform the following actions:

  # aws_security_group.example["group1"] will be created
  + resource "aws_security_group" "example" {
      + arn                    = (known after apply)
      + description            = "Security group created dynamically."
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "10.0.1.0/24",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 65535
            },
          + {
              + cidr_blocks      = [
                  + "192.168.1.0/24",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = "dynamic-sg-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_security_group.example["group2"] will be created
  + resource "aws_security_group" "example" {
      + arn                    = (known after apply)
      + description            = "Security group created dynamically."
      + egress                 = (known after apply)
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "172.16.1.0/24",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 65535
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = "dynamic-sg-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.this will be created
  + resource "aws_subnet" "this" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = (known after apply)
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.this will be created
  + resource "aws_vpc" "this" {
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
      + tags_all                             = (known after apply)
    }

Plan: 4 to add, 0 to change, 0 to destroy.
aws_vpc.this: Creating...
aws_security_group.example["group2"]: Creating...
aws_security_group.example["group1"]: Creating...
aws_vpc.this: Creation complete after 3s [id=vpc-01d9f05fd685455eb]
aws_subnet.this: Creating...
aws_security_group.example["group2"]: Creation complete after 4s [id=sg-0a927a2637a1a346e]
aws_security_group.example["group1"]: Creation complete after 4s [id=sg-0cd2ac5848f832147]
aws_subnet.this: Creation complete after 1s [id=subnet-0ca3f1a8ace2ff7a2]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

## Benefits

- **Code Reusability**: Dynamic blocks reduce the need for copy-pasting code and promote reusability by generating nested blocks based on input data.
- **Scalability**: Handling multiple resources or configurations becomes more efficient and scalable with dynamic blocks, especially when dealing with large datasets.
- **Cleaner Configurations**: Dynamic blocks help keep the configuration files concise and organized, enhancing readability and maintainability.

Dynamic blocks in Terraform are a valuable feature that simplifies the management of complex infrastructure configurations by enabling more flexibility and automation.


## Best Practices for Dynamic Blocks

Use it in a module to hide details or complexity and make it clean and reusable


## Sample dynamic block for Azure

This example creates an Azure virtual machine and dynamically defines multiple network interfaces based on a list of NIC names provided.


```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefix       = "10.0.1.0/24"
}

variable "nic_names" {
  type    = list(string)
  default = ["nic1", "nic2", "nic3"]
}

resource "azurerm_network_interface" "example" {
  count               = length(var.nic_names)
  name                = "nic-${var.nic_names[count.index]}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = azurerm_network_interface.example[*].id

  vm_size              = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "example-vm"
    admin_username = "adminuser"
    admin_password = "P@ssword1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
```

In this example, we use a dynamic block expression for the creation of network interfaces (`azurerm_network_interface`). The number of network interfaces is determined by the length of the `nic_names` list variable. The resource block is repeated for each element in the list, and the name of the network interface is set dynamically using the `count.index`.

Remember to adjust the `nic_names` variable with your desired names for network interfaces. Also, ensure you have the appropriate Azure credentials set up to execute the Terraform configuration successfully.

## Sample dynamic block for GCP

This example demonstrates how to create multiple Google Compute Engine instances using dynamic blocks.


```hcl
provider "google" {
  credentials = file("<YOUR_GCP_CREDENTIALS_FILE>")
  project     = "<YOUR_GCP_PROJECT_ID>"
  region      = "<YOUR_GCP_REGION>"
}

resource "google_compute_instance" "vm_instance" {
  name         = "vm-instance"
  machine_type = "n1-standard-1"
  zone         = "<YOUR_GCP_ZONE>"

  dynamic "network_interface" {
    for_each = var.networks

    content {
      network = network_interface.value["network"]
    }
  }
}
```

In this example, you need to replace the placeholders enclosed in angle brackets (`< >`) with your actual values:

- `<YOUR_GCP_CREDENTIALS_FILE>`: Path to the file containing your GCP service account credentials.
- `<YOUR_GCP_PROJECT_ID>`: Your GCP project ID where you want to create the instances.
- `<YOUR_GCP_REGION>`: The region in which you want to deploy the instances.
- `<YOUR_GCP_ZONE>`: The specific zone within the region where you want to create the instances.

Additionally, you will need to define the `var.networks` variable in your Terraform configuration. This variable should be a map containing the network configurations for each instance you want to create. Here's an example of how you can define the `var.networks` variable in a `.tfvars` file:

```hcl
networks = {
  instance1 = {
    network = "default"
  },
  instance2 = {
    network = "custom-network"
  },
  instance3 = {
    network = "another-network"
  }
}
```

With this configuration, Terraform will create three Google Compute Engine instances named `vm-instance-instance1`, `vm-instance-instance2`, and `vm-instance-instance3`, each attached to the specified network.

Remember to execute `terraform init`, `terraform plan`, and `terraform apply` to apply this configuration to your GCP environment.


Make sure to adapt the configuration based on your specific requirements, such as the number of instances, instance names, machine types, and other properties. Additionally, ensure that you have the necessary access and permissions in your GCP project to create instances and other resources.



## Sample dynamic block for AWS 
This example is to create an AWS EC2 instance in markdown format:

```hcl
resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  count         = 3

  dynamic "security_group" {
    for_each = var.security_groups

    content {
      name = security_group.value
    }
  }

  tags = {
    Name = "Example Instance"
  }
}

variable "security_groups" {
  type = map(string)
  default = {
    "sg1" = "SecurityGroup1"
    "sg2" = "SecurityGroup2"
    "sg3" = "SecurityGroup3"
  }
}
```

In this example, we use a dynamic block to create multiple security groups for the EC2 instances. The `count` argument is set to 3, which means it will create 3 EC2 instances. The `security_groups` variable is defined as a map with default values, but you can customize it as needed.

Each instance will be associated with one of the security groups defined in the `security_groups` map. The `for_each` loop in the dynamic block iterates over the elements of the `security_groups` map, creating a separate security group block for each entry.

Please make sure to replace the `ami`, `instance_type`, and other values with appropriate values for your use case. Also, ensure you have valid AWS credentials set up to execute this Terraform configuration.

---

Here's an other example for creating an AWS security group rules using dynamic blocks:  


```hcl
resource "aws_security_group" "example" {
  name_prefix = "example-sg"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.security_group_rules

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

variable "security_group_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

# Example variable values for the security_group_rules variable
variable "security_group_rules" {
  default = {
    http = {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]
    },
    custom_tcp = {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = ["192.168.1.0/24", "192.168.2.0/24"]
    },
  }
}
```

In this example, we're creating an AWS security group resource with a dynamic block for ingress rules. The `for_each` parameter allows us to loop through the `security_group_rules` variable, which is of type `map(object(...))`. This variable contains different security group rules defined as objects, each having specific ports, protocols, and CIDR blocks.

This sample Terraform code creates an AWS security group with the specified ingress rules. Make sure to replace the VPC ID (`aws_vpc.main.id`) with your actual VPC ID or reference it from another resource. Also, adjust the `variable "security_group_rules"` to match the security group rules you want to define.

---

Happy Terraforming!
