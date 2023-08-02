# HCTA Section 2 - Terraform Purpose

Section | Description |
------- | ----------- |  
**2**	| **Understand the purpose of Terraform (vs other IaC)**
2a	| Explain multi-cloud and provider-agnostic benefits
2b	| Explain the benefits of state

---  

## 2a	- Explain multi-cloud and provider-agnostic benefits

Provisioning infrastructure across multiple clouds increases fault-tolerance, allowing for more graceful recovery from cloud provider outages. However, multi-cloud deployments add complexity because each provider has its own interfaces, tools, and workflows. Terraform lets you use the same workflow to manage multiple providers and handle cross-cloud dependencies. This simplifies management and orchestration for large-scale, multi-cloud infrastructures.

HashiCorp Terraform is an infrastructure as code tool that lets you define both cloud and on-prem resources in human-readable configuration files that you can version, reuse, and share. You can then use a consistent workflow to provision and manage all of your infrastructure throughout its lifecycle. 

The core Terraform workflow consists of three stages:
- **Write**: You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.
- **Plan**: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
- **Apply**: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.


---  

## 2b	- Explain the benefits of state

During execution, Terraform will examine the state of the currently running infrastructure, determine what differences exist between the current state and the revised desired state, and indicate the necessary changes that must be applied. When approved to proceed, **only the necessary changes will be applied, leaving existing, valid infrastructure untouched**.

In addition to basic mapping, Terraform stores a cache of the attribute values for all resources in the state. This is the most optional feature of Terraform state and is done only as a **performance improvement**.