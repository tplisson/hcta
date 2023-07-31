# HCTA Section 4 - Use Terraform outside the core workflow

## Exam objectives

Section | Description |
------- | ----------- |  
**4**	| **Use Terraform outside of core workflow**
4a	Describe when to use terraform import to import existing infrastructure into your Terraform state
4b	Use terraform state to view Terraform state
4c	Describe when to enable verbose logging and what the outcome/value is

---  

## 4a - Describe when to use terraform import to import existing infrastructure into your Terraform state

---  

## 4b - Use `terraform state` to view Terraform state

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

---  

## 4c - Describe when to enable verbose logging and what the outcome/value is


---  
