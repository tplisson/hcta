# Terraform CLI

Documentation:
https://developer.hashicorp.com/terraform/cli/

Terraform workflow

```console
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

## Terraform Workspaces

See section on [Terraform workplaces](../workspaces/)

## Format

Formating Terraform code for readability and consistency
```console
terraform fmt 
```

## Validate

Running checks to verify whether a configuration is syntactically valid and internally consistent

Formating Terraform code for readability and consistency
```console
terraform validate 
```
```console
Success! The configuration is valid.
```

## Taint

Use `taint` to force a resource to be destroyed and recreated. 
Use cases:
- trigger `provisionners` to run
- replace misbehaving resources forcefully
- trigger automation initiated during resource recreation (API calls...etc)

Tainting a resource
```console
terraform taint <RESOURCE_ADDRESS>
```

Tainting an AWS subnet:  

```console
terraform state list
```
```terraform
aws_subnet.subnet1
aws_vpc.cli
```

```console
terraform taint aws_subnet.subnet1
```
```terraform
Resource instance aws_subnet.subnet1 has been marked as tainted.
```
```console
terraform apply --auto-approve
```
```terraform
aws_vpc.cli: Refreshing state... [id=vpc-010cac9b5d463d82e]
aws_subnet.subnet1: Refreshing state... [id=subnet-01e5c24d4dbcd8a99]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
-/+ destroy and then create replacement

Terraform will perform the following actions:

  # aws_subnet.subnet1 is tainted, so must be replaced
-/+ resource "aws_subnet" "subnet1" {
      ~ arn                                            = "arn:aws:ec2:us-east-1:431229157735:subnet/subnet-01e5c24d4dbcd8a99" -> (known after apply)
      ~ availability_zone                              = "us-east-1b" -> (known after apply)
      ~ availability_zone_id                           = "use1-az4" -> (known after apply)
      - enable_lni_at_device_index                     = 0 -> null
      ~ id                                             = "subnet-01e5c24d4dbcd8a99" -> (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      - map_customer_owned_ip_on_launch                = false -> null
      ~ owner_id                                       = "431229157735" -> (known after apply)
      ~ private_dns_hostname_type_on_launch            = "ip-name" -> (known after apply)
        tags                                           = {
            "Name" = "subnet1"
        }
        # (9 unchanged attributes hidden)
    }

Plan: 1 to add, 0 to change, 1 to destroy.
aws_subnet.subnet1: Destroying... [id=subnet-01e5c24d4dbcd8a99]
aws_subnet.subnet1: Destruction complete after 1s
aws_subnet.subnet1: Creating...
aws_subnet.subnet1: Creation complete after 1s [id=subnet-0b792a26fecba7321]

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
```


## Shell aliases

Using aliases in Bash / Zsh shell can be handy :)
```zsh
alias tf='terraform'
alias tfi='terraform init'
alias tff='terraform fmt'
alias tfv='terraform validate'
alias tfp='terraform plan'
alias tfa='terraform apply -auto-approve'
alias tfd='terraform destroy -auto-approve'
```
  

```console
 tfv
```
```terraform
Success! The configuration is valid.
```