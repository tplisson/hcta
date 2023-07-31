# Terraform State

Documentation:
https://developer.hashicorp.com/terraform/language/state/

## Overview

Terraform must store state about your managed infrastructure and configuration. This state is used by Terraform to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures.

- Local state: By default, Terraform stores state locally in a file named `terraform.tfstate`. 
- Remote State: Terraform supports storing state in Terraform Cloud, HashiCorp Consul, Amazon S3, Azure Blob Storage, Google Cloud Storage, Alibaba Cloud OSS, and more.

### Terraform State List  

To list resources within a Terraform state.

```console
terraform state list
```
```terraform 
aws_instance.foo
aws_instance.bar[0]
aws_instance.bar[1]
module.elb.aws_elb.main
```

Filtering by Resource  

```console
terraform state list aws_instance.bar
```
```terraform 
aws_instance.bar[0]
aws_instance.bar[1]
```

Filtering by Module  

```console
terraform state list module.elb
```
```terraform 
module.elb.aws_elb.main
module.elb.module.secgroups.aws_security_group.sg
```

### Terraform State Show  

To provide human-readable output from a state or plan file. 

```console
terraform state show module.vpc.aws_subnet.this
```
```terraform 
resource "aws_subnet" "this" {
    arn                                            = "arn:aws:ec2:us-east-1:312939059436:subnet/subnet-0ea5b69336332dd6e"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1f"
    availability_zone_id                           = "use1-az5"
    cidr_block                                     = "10.0.1.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-0ea5b69336332dd6e"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = false
    owner_id                                       = "312939059436"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-00d73267a5b1af622"
}
```

### Terraform State Outputs  

Extract the value of an output variable from the state file.

`outputs.tf` file:
```hcl
output "instance_ips" {
  value = aws_instance.web.*.public_ip
}

output "lb_address" {
  value = aws_alb.web.public_dns
}

output "password" {
  sensitive = true
  value     = var.secret_password
}
```

```console
terraform output
```
```terraform
instance_ips = [
  "54.43.114.12",
  "52.122.13.4",
  "52.4.116.53"
]
lb_address = "my-app-alb-1657023003.us-east-1.elb.amazonaws.com"
password = <sensitive>


```console
terraform output instance_ips
```
```terraform
instance_ips = [
  "54.43.114.12",
  "52.122.13.4",
  "52.4.116.53"
]
```

```console
terraform output lb_address
```
```terraform
"my-app-alb-1657023003.us-east-1.elb.amazonaws.com"
```

### Terraform State Imports

Importing externally-created objects with terraform import

First write a resource block for it in your configuration, establishing the name by which it will be known to Terraform:

```hcl
resource "aws_instance" "example" {
  # ...instance configuration...
}
```

Now `terraform import` can be run to attach an existing instance to this resource configuration: 

```console
terraform import aws_vpc.import vpc-05483b423b9e04565 
```
```terraform
aws_vpc.import: Importing from ID "vpc-05483b423b9e04565"...
aws_vpc.import: Import prepared!
  Prepared aws_vpc for import
aws_vpc.import: Refreshing state... [id=vpc-05483b423b9e04565]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
```

```console
terraform state list                                 
```
```terraform
aws_instance.my-instance
aws_vpc.import
```


Terraform can generate code for the resources you define in import blocks that do not already exist in your configuration. 
https://developer.hashicorp.com/terraform/language/import/generating-configuration

`import.tf`
```hcl
import {
  to = aws_vpc.import
  id = "vpc-05483b423b9e04565"
}
```

```console
terraform plan -generate-config-out=generated.tf
```
```terraform
aws_vpc.import: Preparing import... [id=vpc-05483b423b9e04565]
aws_vpc.import: Refreshing state... [id=vpc-05483b423b9e04565]
```

Rendered `generated.tf` file:
```hcl
# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform
resource "aws_vpc" "import" {
  assign_generated_ipv6_cidr_block     = false
  cidr_block                           = "10.0.0.0/24"
  enable_dns_hostnames                 = false
  enable_dns_support                   = true
  enable_network_address_usage_metrics = false
  instance_tenancy                     = "default"
  ipv4_ipam_pool_id                    = null
  ipv4_netmask_length                  = null
  ipv6_cidr_block                      = null
  ipv6_cidr_block_network_border_group = null
  ipv6_ipam_pool_id                    = null
  ipv6_netmask_length                  = 0
  tags = {
    Name = "new_vpc_created_from_aws_ui"
  }
  tags_all = {
    Name = "new_vpc_created_from_aws_ui"
  }
}
```


### Terraform State Delete

To remove an existing resources from the state file use the `terraform state rm`.
This does not remove the resource from your configuration or destroy the infrastructure itself.

```console
terraform state list
```
```terraform
Removed aws_vpc.to_be_deleted
```
```console
terraform state rm aws_vpc.to_be_deleted
```
```terraform
Removed aws_vpc.to_be_deleted
Successfully removed 1 resource instance(s).
```


## Remote state

Storing TF state remotely provides granular access, integrity, security, availability, and collaboration.

A backend defines where Terraform stores its state data files.

Available Backends
- [Local](#local)
- [Remote](#remote)
- [Amazon S3](#amazon-s3)
- [Azure Blob Storage ](#azure-blob-storage)
- [Consul](#consul)
- [Google Cloud Storage](#google-cloud-storage)
- [Kubernetes](#kubernetes)
- [PostGRES Database](#postgres-database)

### Local 

By default, TF state is stored in local file `terraform.tfstate`

### Remote 

Using Terraform Cloud 

```hcl
terraform {
  backend "remote" {
    organization = "example_corp"

    workspaces {
      name = "my-app-prod"
    }
  }
}
```

### Amazon S3

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}
```

### Azure Blob Storage 

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "StorageAccount-ResourceGroup"
    storage_account_name = "abcd1234"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

### Consul

```hcl
terraform {
  backend "consul" {
    address = "consul.example.com"
    scheme  = "https"
    path    = "full/path"
  }
}
```

### Google Cloud Storage 

```hcl
terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}
```

### Kubernetes

```hcl
terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "~/.kube/config"
  }
}
```

### PostGRES Database

```hcl
terraform {
  backend "pg" {
    conn_str = "postgres://user:pass@db.example.com/terraform_backend"
  }
}
```
