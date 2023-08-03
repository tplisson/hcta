# pre-commit Hooks

`terraform fmt` command
https://developer.hashicorp.com/terraform/cli/commands/fmt  

terraform-docs  
https://terraform-docs.io/how-to/pre-commit-hooks/  

```sh
#!/bin/sh
#
# My simple git pre-commit hooks 
#
# Location: .git/hooks/pre-commit
#

# Keep module Terraform files formatted
terraform fmt -recursive

# Keep module docs up to date
for d in */*/modules/*; do
  if terraform-docs md "$d" > "$d/README.md"; then
    git add "./$d/README.md"
  fi
done
```