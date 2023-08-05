# HCTA Section 7 - Implement and maintain state

## Exam objectives


Section | Description |
------- | ----------- |  
**7** | **Implement and maintain state**
7a | [Describe default local backend](#7a--describe-default-local-backend)
7b | [Describe state locking](#7b--describe-state-locking)
7c | [Handle backend and cloud integration authentication methods](#7c--handle-backend-and-cloud-integration-authentication-methods)
7d | [Differentiate remote state back end options](#7d--differentiate-remote-state-back-end-options)
7e | [Manage resource drift and Terraform state](#7e--manage-resource-drift-and-terraform-state)
7f | [Describe backend block and cloud integration in configuration](#7f--describe-backend-block-and-cloud-integration-in-configuration)
7g | [Understand secret management in state files](#7g--understand-secret-management-in-state-files)


---  

## 7a - Describe default local backend    

Backends define where Terraform's state snapshots are stored.

If a configuration includes no backend block, Terraform defaults to using the `local` backend, which stores state as a plain file in the current working directory.

```hcl
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
  }
}
```

---  

## 7b	- Describe state locking  

If supported by your backend*, Terraform will lock your state for all operations that could write state. This prevents others from acquiring the lock and potentially corrupting your state.

  *Note*: Some backends act like plain "remote disks" for state files; others support locking the state while operations are being performed, which helps prevent conflicts and inconsistencies.

---  

## 7c	- Handle backend and cloud integration authentication methods  


### CLI    

The `terraform login` command can be used to automatically obtain and save an API token for Terraform Cloud, Terraform Enterprise, or any other host that offers Terraform services. This is valide if you are running the Terraform CLI interactively.

Usage: 
```shell
terraform login [hostname]
```
*Note*: If you don't provide an explicit hostname, Terraform will assume you want to log in* to Terraform Cloud at `app.terraform.io`.

### `credentials` blocks   

Otherwise, you can manually write `credentials` blocks.

```hcl
credentials "app.terraform.io" {
  token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
}
```

### `TF_TOKEN_` Environment variable  

If you would prefer not to store your API tokens directly in the CLI configuration, you may use a host-specific environment variable. 

Environment variable names should have the prefix `TF_TOKEN_`` added to the domain name, with periods encoded as underscores. 

For example, for hostname `app.terraform.io`:
```hcl
TF_TOKEN_app_terraform_io
```

### Credentials Helpers  

You can configure a credentials_helper to instruct Terraform to use a different credentials storage mechanism.

```hcl
credentials_helper "example" {
  args = []
}
```

---  

## 7d	- Differentiate remote state backend options   

A backend defines where Terraform stores its state data files.
Storing TF state remotely provides granular access, integrity, security, availability, and collaboration.

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


### The `terraform_remote_state` Data Source

The `terraform_remote_state` data source uses the latest state snapshot from a specified state backend to retrieve the root module output values from some other Terraform configuration.

When using remote state, root module outputs can be accessed by other configurations via a `terraform_remote_state` data source.

#### Example Usage (`remote` Backend)

```hcl
data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "hashicorp"
    workspaces = {
      name = "vpc-prod"
    }
  }
}

# Terraform >= 0.12
resource "aws_instance" "foo" {
  # ...
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
}

# Terraform <= 0.11
resource "aws_instance" "foo" {
  # ...
  subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
}
```

#### Example Usage (`local` Backend)

```hcl
data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "..."
  }
}

# Terraform >= 0.12
resource "aws_instance" "foo" {
  # ...
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id
}

# Terraform <= 0.11
resource "aws_instance" "foo" {
  # ...
  subnet_id = "${data.terraform_remote_state.vpc.subnet_id}"
}
```



---  

## 7e	- Manage resource drift and Terraform state   

### Drift  
The Terraform state file is a record of all resources Terraform manages. You should not make manual changes to resources controlled by Terraform, because the state file will be out of sync, or "drift," from the real infrastructure. If your state and configuration do not match your infrastructure, Terraform will attempt to reconcile your infrastructure, which may unintentionally destroy or recreate resources.

Terraform relies on the contents of your workspace's state file to generate an execution plan to make changes to your resources. To ensure the accuracy of the proposed changes, your state file must be up to date.

### `Terraform refresh`

In Terraform, refreshing your state file updates Terraform's knowledge of your infrastructure, as represented in your state file, with the actual state of your infrastructure. 

Usage
```shell
terraform refresh
```

Terraform `plan` and `apply` operations run an implicit in-memory refresh as part of their functionality, reconciling any drift from your state file before suggesting infrastructure changes. 

### `-refresh-only` flag

The `-refresh-only` flag for `plan` and `apply` operations makes it safer to check Terraform state against real infrastructure by letting you review proposed changes to the state file. 

Usage
```shell
terraform plan -refresh-only
terraform apply -refresh-only
```


---  

## 7f	- Describe backend block and cloud integration in configuration

If a configuration includes no backend block, Terraform defaults to using the `local` backend, which stores state as a plain file in the current working directory.

Backends are configured with a nested `backend` block within the top-level `terraform` block:

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

---  

## 7g	- Understand secret management in state files

Terraform state can contain sensitive data. For resources such as databases, this may contain initial passwords.

When using local state, state is stored in plain-text JSON files.

When using remote state, state is only ever held in memory when used by Terraform. It may be encrypted at rest, but this depends on the specific remote state backend.

**If you manage any sensitive data with Terraform (like database passwords, user passwords, or private keys), treat the state itself as sensitive data.**

Storing state remotely can provide better security.

- Terraform Cloud always encrypts state at rest and protects it with TLS in transit.
- The S3 backend supports encryption at rest when the encrypt option is enabled. Requests for the state go over a TLS connection.
- HashiCorp Vault secures, stores, and tightly controls access to tokens, passwords, and other sensitive values.  

The approach to secret injection:
- alleviates the Vault Admin's responsibility in managing numerous, multi-scoped, long-lived AWS credentials,
- reduces the risk from a compromised AWS credential in a Terraform run (if a malicious user gains access to an AWS credential used in a Terraform run, that credential is only value for the length of the token's TTL),
- allows for management of a role's permissions through a Vault role rather than the distribution/management of static AWS credentials,
- enables development to provision resources without managing local, static AWS credentials

See Tutorial:
Inject Secrets into Terraform Using the Vault Provider
https://developer.hashicorp.com/terraform/tutorials/secrets/secrets-vault  

---  
