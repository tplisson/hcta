# Debugging Terraform

Documentation:
https://developer.hashicorp.com/terraform/internals/debugging
  

## Detailed logs

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


```console
export TF_LOG=INFO
```

```console
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

```console
export TF_LOG=TRACE
export TF_LOG_PATH=terraform.log
```
  

```console
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

```console
cat terraform.log 
```
```console
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

