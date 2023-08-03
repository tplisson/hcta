# HCTA Section 9 - Terraform Cloud

Documentation:  
https://developer.hashicorp.com/terraform/cloud-docs

## Exam objectives

Section | Description |
------- | ----------- |  
**9** |	**Understand Terraform Cloud capabilities**
9a	| [Explain how Terraform Cloud helps to manage infrastructure](#9a--explain-how-terraform-cloud-helps-to-manage-infrastructure)
9b	| [Describe how Terraform Cloud enables collaboration and governance](#9b--describe-how-terraform-cloud-enables-collaboration-and-governance)

---   

## 9a	- Explain how Terraform Cloud helps to manage infrastructure  

Terraform Cloud helps teams collaborate on Infrastructure as Code by providing a stable and reliable environment for operations, shared state and secret data, access controls to manage permissions for team members, and a policy framework for governance.  

Terraform Cloud is a commercial SaaS product available at https://app.terraform.io.   
  
How can you collaborate to manage infrastructure as code if Terraform state is stored on a local machine ? 
Terraform Cloud solves this (and many more) by offering these features:
- remote Terraform execution
- workspace-based organizational model
- version control integration
- command-line integration 
- remote state management with cross-workspace data sharing
- private Terraform module registry
- Cost estimation (AWS, Azure, GCP)
- Sentinel integration (Policy-as-Code framework)


Terraform Cloud has 3 main workflows for managing runs:
- The **UI/VCS-driven run workflow**, which is the primary mode of operation.
- The **API-driven run workflow**, which is more flexible but requires you to create some tooling.
- The **CLI-driven run workflow**, which uses Terraform's standard CLI tools to execute runs in Terraform Cloud.

---  

## 9b	- Describe how Terraform Cloud enables collaboration and governance  

Terraform Cloud offers a team-oriented remote Terraform workflow.  

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

Documentation
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

### Remote Terraform Execution
Terraform Cloud runs Terraform on disposable virtual machines in its own cloud infrastructure by default. 

You can leverage Terraform Cloud Agents to run Terraform on your own isolated, private, or on-premises infrastructure.

### Remote State Management, Data Sharing, and Run Triggers

Terraform Cloud acts as a remote backend for your Terraform state. State storage is tied to workspaces, which helps keep state associated with the configuration that created it.

### Version Control Integration

Each workspace can be linked to a VCS repository that contains its Terraform configuration. 
Terraform Cloud automatically retrieves configuration content from the repository, and will also watch the repository for changes:
- When *new commits* are merged, linked workspaces automatically run Terraform plans with the new code
- When *pull requests* are opened, linked workspaces run speculative plans with the proposed code changes and post the results as a pull request check; reviewers can see at a glance whether the plan was successful, and can click through to view the proposed changes in detail.

### Command Line Integration

Configure the Terraform Cloud CLI integration, and the terraform plan command will start a remote run in the configured Terraform Cloud workspace. 

---  
