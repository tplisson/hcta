# Terraform CLI

Documentation:
https://developer.hashicorp.com/terraform/cli/


```console
terraform validate
terraform plan
terraform apply
```


```console
terraform fmt 
```

Tainting a resource
```console
terraform taint <RESOURCE_ADDRESS>
```

Use `taint` to force a resource to be destroyed and recreated. 
Use cases:
- trigger `provisionners` to run
- replace misbehaving resources forcefully
- trigger automation initiated during resource recreation (API calls...etc)

