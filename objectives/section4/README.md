# HCTA Section 4 - Use Terraform outside the core workflow

## Exam objectives

Section | Description |
------- | ----------- |  
**4**	| **Use Terraform outside of core workflow**
4a | [Describe when to use terraform import to import existing infrastructure into your Terraform state](#4a--describe-when-to-use-terraform-import-to-import-existing-infrastructure-into-your-terraform-state)
4b | [Use terraform state to view Terraform state](#4b--use-terraform-state-to-view-terraform-state)
4c | [Describe when to enable verbose logging and what the outcome/value is](#4c--describe-when-to-enable-verbose-logging-and-what-the-outcomevalue-is)

---  

## 4a - Describe when to use `terraform import` to import existing infrastructure into your Terraform state  

Use [`terraform import`](https://developer.hashicorp.com/terraform/language/import) when you want Terraform to manage resources that have already been deployed.  

***Note***: *Be careful to import each remote object to only one Terraform resource address.*  

### Importing externally-created objects with `terraform import`   

First write a resource block for it in your configuration, establishing the name by which it will be known to Terraform:  

```hcl
resource "aws_instance" "example" {
  # ...instance configuration...
}
```

Now run `terraform import` to attach an existing instance to this resource configuration.

Usage:
```shell
terraform import <resource-address> <resource-specific-ID>
```

Example:
```shell
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

```shell
terraform state list                                 
```
```terraform
aws_instance.my-instance
aws_vpc.import
```


Optionally, Terraform can [generate code](https://developer.hashicorp.com/terraform/language/import/generating-configuration) for the resources you define in import blocks that do not already exist in your configuration. 


`imports.tf`
```hcl
import {
  to = aws_vpc.import
  id = "vpc-05483b423b9e04565"
}
```

```shell
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
  
Review the generated configuration and update it as needed. You may wish to move the generated configuration to another file such as your `main.tf` file.

---  

## 4b - Use `terraform state` to view Terraform state  

To list resources within a Terraform state.

```shell
terraform state list
```
```terraform 
aws_instance.foo
aws_instance.bar[0]
aws_instance.bar[1]
module.elb.aws_elb.main
```

Filtering by Resource  

```shell
terraform state list aws_instance.bar
```
```terraform 
aws_instance.bar[0]
aws_instance.bar[1]
```

Filtering by Module  

```shell
terraform state list module.elb
```
```terraform 
module.elb.aws_elb.main
module.elb.module.secgroups.aws_security_group.sg
```

### Terraform State Show   

To provide human-readable output from a state or plan file. 

```shell
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

`outputs.tf`
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

```shell
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
```

```shell
terraform output instance_ips
```
```terraform
instance_ips = [
  "54.43.114.12",
  "52.122.13.4",
  "52.4.116.53"
]
```

```shell
terraform output lb_address
```
```terraform
"my-app-alb-1657023003.us-east-1.elb.amazonaws.com"
```

---  

## 4c - Describe when to enable verbose logging and what the outcome/value is  

Terraform has detailed logs that you can enable by setting the `TF_LOG` environment variable.

Environment variables
- `TF_LOG`
  - Enabling this setting causes detailed logs to appear on `stderr`.
  - Debug levels (in order of verbosity):
    - `OFF`
    - `ERROR`
    - `WARN`
    - `INFO`
    - `DEBUG`
    - `TRACE`
- `TF_LOG_PATH`
  - storing logs to a local file (persistant storage instead of `stderr`)


```shell
export TF_LOG=INFO
```

```shell
terraform init
```
```terraform
2023-07-31T15:04:12.464+0200 [INFO]  Terraform version: 1.5.4
2023-07-31T15:04:12.465+0200 [INFO]  Go runtime version: go1.20.6
2023-07-31T15:04:12.465+0200 [INFO]  CLI args: []string{"terraform", "init"}
2023-07-31T15:04:12.467+0200 [INFO]  CLI command args: []string{"init"}

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v5.10.0...
- Installed hashicorp/aws v5.10.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```


Storing logs in a local file

```shell
export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log
```
  

```shell
terraform init
```

```terraform

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of hashicorp/aws from the dependency lock file
- Using previously-installed hashicorp/aws v5.10.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```shell
cat terraform.log 
```
```shell
2023-07-31T15:15:37.797+0200 [INFO]  Terraform version: 1.5.4
2023-07-31T15:15:37.798+0200 [DEBUG] using github.com/hashicorp/go-tfe v1.26.0
2023-07-31T15:15:37.798+0200 [DEBUG] using github.com/hashicorp/hcl/v2 v2.16.2
2023-07-31T15:15:37.798+0200 [DEBUG] using github.com/hashicorp/terraform-svchost v0.1.0
2023-07-31T15:15:37.798+0200 [DEBUG] using github.com/zclconf/go-cty v1.12.2
2023-07-31T15:15:37.798+0200 [INFO]  Go runtime version: go1.20.6
2023-07-31T15:15:37.798+0200 [INFO]  CLI args: []string{"terraform", "init"}
2023-07-31T15:15:37.798+0200 [TRACE] Stdout is a terminal of width 132
2023-07-31T15:15:37.798+0200 [TRACE] Stderr is a terminal of width 132
2023-07-31T15:15:37.798+0200 [TRACE] Stdin is a terminal
2023-07-31T15:15:37.798+0200 [DEBUG] Attempting to open CLI config file: /Users/tom/.terraformrc
2023-07-31T15:15:37.798+0200 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2023-07-31T15:15:37.799+0200 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2023-07-31T15:15:37.799+0200 [DEBUG] ignoring non-existing provider search directory /Users/tom/.terraform.d/plugins
2023-07-31T15:15:37.799+0200 [DEBUG] ignoring non-existing provider search directory /Users/tom/Library/Application Support/io.terraform/plugins
2023-07-31T15:15:37.799+0200 [DEBUG] ignoring non-existing provider search directory /Library/Application Support/io.terraform/plugins
2023-07-31T15:15:37.800+0200 [INFO]  CLI command args: []string{"init"}
2023-07-31T15:15:37.804+0200 [TRACE] Meta.Backend: no config given or present on disk, so returning nil config
2023-07-31T15:15:37.805+0200 [TRACE] Meta.Backend: backend has not previously been initialized in this working directory
2023-07-31T15:15:37.805+0200 [DEBUG] New state was assigned lineage "11f71b70-92a5-c6c0-6084-70ad893304c3"
2023-07-31T15:15:37.805+0200 [TRACE] Meta.Backend: using default local state only (no backend configuration, and no existing initialized backend)
2023-07-31T15:15:37.805+0200 [TRACE] Meta.Backend: instantiated backend of type <nil>
2023-07-31T15:15:37.810+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2023-07-31T15:15:37.812+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.10.0 for darwin_arm64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.10.0/darwin_arm64
2023-07-31T15:15:37.812+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.10.0/darwin_arm64 as a candidate package for registry.terraform.io/hashicorp/aws 5.10.0
2023-07-31T15:15:38.032+0200 [DEBUG] checking for provisioner in "."
2023-07-31T15:15:38.037+0200 [DEBUG] checking for provisioner in "/opt/homebrew/bin"
2023-07-31T15:15:38.037+0200 [TRACE] Meta.Backend: backend <nil> does not support operations, so wrapping it in a local backend
2023-07-31T15:15:38.038+0200 [TRACE] backend/local: state manager for workspace "default" will:
 - read initial snapshot from terraform.tfstate
 - write new snapshots to terraform.tfstate
 - create any backup at terraform.tfstate.backup
2023-07-31T15:15:38.038+0200 [TRACE] statemgr.Filesystem: reading initial snapshot from terraform.tfstate
2023-07-31T15:15:38.038+0200 [TRACE] statemgr.Filesystem: snapshot file has nil snapshot, but that's okay
2023-07-31T15:15:38.038+0200 [TRACE] statemgr.Filesystem: read nil snapshot
2023-07-31T15:15:38.040+0200 [DEBUG] Service discovery for registry.terraform.io at https://registry.terraform.io/.well-known/terraform.json
2023-07-31T15:15:38.040+0200 [TRACE] HTTP client GET request to https://registry.terraform.io/.well-known/terraform.json
2023-07-31T15:15:38.164+0200 [DEBUG] GET https://registry.terraform.io/v1/providers/hashicorp/aws/versions
2023-07-31T15:15:38.164+0200 [TRACE] HTTP client GET request to https://registry.terraform.io/v1/providers/hashicorp/aws/versions
2023-07-31T15:15:38.241+0200 [TRACE] providercache.fillMetaCache: scanning directory .terraform/providers
2023-07-31T15:15:38.243+0200 [TRACE] getproviders.SearchLocalDirectory: found registry.terraform.io/hashicorp/aws v5.10.0 for darwin_arm64 at .terraform/providers/registry.terraform.io/hashicorp/aws/5.10.0/darwin_arm64
2023-07-31T15:15:38.243+0200 [TRACE] providercache.fillMetaCache: including .terraform/providers/registry.terraform.io/hashicorp/aws/5.10.0/darwin_arm64 as a candidate package for registry.terraform.io/hashicorp/aws 5.10.0
```
  

Logging can be enabled separately for terraform itself and the provider plugins using the `TF_LOG_CORE` or `TF_LOG_PROVIDER` environment variables. These take the same level arguments as TF_LOG, but only activate a subset of the logs.


---  
