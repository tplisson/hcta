# HCTA Section 9 - Terraform Cloud

Documentation:
https://developer.hashicorp.com/terraform/cloud-docs

Terraform Cloud is available as a hosted service at https://app.terraform.io. 
You can leverage Terraform Cloud Agents to run Terraform on your own isolated, private, or on-premises infrastructure.

## Exam objectives

Section | Description |
------- | ----------- |  
**9** |	**Understand Terraform Cloud capabilities**
9a	| Explain how Terraform Cloud helps to manage infrastructure
9b	| Describe how Terraform Cloud enables collaboration and governance


## 9a	- Explain how Terraform Cloud helps to manage infrastructure

Terraform Cloud helps teams collaborate on Infrastructure as Code by providing a stable and reliable environment for operations, shared state and secret data, access controls to manage permissions for team members, and a policy framework for governance.

## 9b	- Describe how Terraform Cloud enables collaboration and governance

Terraform Cloud offers a team-oriented remote Terraform workflow. 

The foundations of this workflow are remote Terraform execution, a workspace-based organizational model, version control integration, command-line integration, remote state management with cross-workspace data sharing, and a private Terraform module registry.

By default, TF state is stored in local file `terraform.tfstate`

To use Terraform Cloud for remote state, set the `remote` backend:

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
### Terraform Cloud Organisations

Organizations are a shared space for one or more teams to collaborate on workspaces.

### Terraform Cloud Users

Each user can be part of one or more teams, which are granted permissions on workspaces within an organization. A user can be a member of multiple organizations.

### Terraform Cloud Teams

https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/teams

Teams are groups of Terraform Cloud users within an organization.

You can grant teams various permissions on workspaces. 

Workspace Permissions:
- Run access:
  - Read
  - Pan
  - Apply
- Variable access:
  - No access
  - Read
  - Read and write
- State access:
  - No access
  - Read
  - Read and write
- Other controls:
  - Download Sentinel mocks
  - Manage Workspace Run Tasks
  - Lock/unlock workspace


Fixed Permission Sets:
- Workspace Admins
- Write
- Plan
- Read

### Execution mode

- Local
- 