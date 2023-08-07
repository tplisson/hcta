# HCTA HashiCorp Certified: Terraform Associate (003) — Study Notes
## HashiCorp Infrastructure Automation Certification

[Exam objectives](https://www.hashicorp.com/certification/terraform-associate)

[Study Guide](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-study-003)

[Review Guide](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-review-003?product_intent=terraform)

[Practical Demos](https://terraformguru.com/terraform-certification-using-aws-cloud/)

<p align="center">
  <img src="images/hcta-badge.webp" {:height="25%" width="25%"}>
</p>
<br/>

---  

## Exam details

Exam Details  |   |
------------- | - |  
Assessment Type	| Multiple choice
Format	| Online proctored
Duration	| 1 hour
Price	| $70.50 USD <sub>plus locally applicable taxes and fees</sub>
Language	| English
Expiration |	2 years

---  

## Exam objectives

| Section | Description     |
| ------- | --------------- |  
| **1**	| **[Understand infrastructure as code (IaC) concepts](objectives/section1)**
| 1a	| Explain what IaC is
| 1b	| Describe advantages of IaC patterns
| **2**	| **[Understand the purpose of Terraform (vs other IaC)](objectives/section2)**
| 2a	| Explain multi-cloud and provider-agnostic benefits
| 2b	| Explain the benefits of state
| **3**	| **[Understand Terraform basics](objectives/section3)**
| 3a | Install and version Terraform providers
| 3b | Describe plugin-based architecture
| 3c | Write Terraform configuration using multiple providers
| 3d | Describe how Terraform finds and fetches providers
| **4**	| **[Use Terraform outside of core workflow](objectives/section4)**
| 4a | Describe when to use terraform import to import existing infrastructure into your Terraform state
| 4b | Use terraform state to view Terraform state
| 4c | Describe when to enable verbose logging and what the outcome/value is
| **5**	| **[Interact with Terraform modules](objectives/section5)**
| 5a | Contrast and use different module source options including the public Terraform Module Registry
| 5b | Interact with module inputs and outputs
| 5c | Describe variable scope within modules/child modules
| 5d | Set module version
| **6**	| **[Use the core Terraform workflow](objectives/section6)**
| 6a | Describe Terraform workflow ( Write -> Plan -> Create )
| 6b | Initialize a Terraform working directory (terraform init)
| 6c | Validate a Terraform configuration (terraform validate)
| 6d | Generate and review an execution plan for Terraform (terraform plan)
| 6e | Execute changes to infrastructure with Terraform (terraform apply)
| 6f | Destroy Terraform managed infrastructure (terraform destroy)
| 6g | Apply formatting and style adjustments to a configuration (terraform fmt)
| **7**	| **[Implement and maintain state](objectives/section7)**
| 7a | Describe default local backend
| 7b | Describe state locking
| 7c | Handle backend and cloud integration authentication methods
| 7d | Differentiate remote state back end options
| 7e | Manage resource drift and Terraform state
| 7f | Describe backend block and cloud integration in configuration
| 7g | Understand secret management in state files
| **8**	| **[Read, generate, and modify configuration](objectives/section8)**
| 8a | Demonstrate use of variables and outputs
| 8b | Describe secure secret injection best practice
| 8c | Understand the use of collection and structural types
| 8d | Create and differentiate resource and data configuration
| 8e | Use resource addressing and resource parameters to connect resources together
| 8f | Use HCL and Terraform functions to write configuration
| 8g | Describe built-in dependency management (order of execution based)
| **9**	| **[Understand Terraform Cloud capabilities](objectives/section9)**
| 9a	| Explain how Terraform Cloud helps to manage infrastructure
| 9b	| Describe how Terraform Cloud enables collaboration and governance



---  

Topic   	| Sample TF files |
--------- | --------------- |
[Terraform CLI](cli/README.md)  | [files](misc/cli/)  |
[Terraform Workspaces](workspaces/README.md)  | [files](misc/workspaces/)  |
[Terraform State](state/README.md)  | [files](misc/state/)  |
[Terraform Input Variables](variables/README.md)  | [files](misc/variables/)  |
[Terraform Plan Outputs](outputs/README.md)  | [files](misc/outputs/) |
[Terraform Built-in Functions ](builtins/README.md)  | [files](misc/builtins/)  |
[Terraform Dynamic Blocks](dynamic/README.md)  | [files](misc/dynamic/)  |
[Debugging Terraform](debugging/README.md)  | [files](misc/debugging/)  |
[Terraform Cloud](tfc/README.md)  | [files](misc/tfc/)  |
[Terraform Enterprise](tfe/README.md)  | [files](misc/tfe/)  |

---  
