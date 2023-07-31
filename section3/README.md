# HCTA Section 3

Section | Description |
------- | ----------- |  
**3**	| **Understand Terraform basics**
3a	Install and version Terraform providers
3b	Describe plugin-based architecture
3c	Write Terraform configuration using multiple providers
3d	Describe how Terraform finds and fetches providers

---  


The core Terraform workflow consists of three stages:

Write: You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.
Plan: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
Apply: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.