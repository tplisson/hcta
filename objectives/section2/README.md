# HCTA Section 2 - Terraform Purpose

Section | Description |
------- | ----------- |  
**2**	| **Understand the purpose of Terraform (vs other IaC)**
2a	| [Explain multi-cloud and provider-agnostic benefits](#2a--explain-multi-cloud-and-provider-agnostic-benefits)
2b	| [Explain the benefits of state](#2b--explain-the-benefits-of-state)

---  

## 2a	- Explain multi-cloud and provider-agnostic benefits

Provisioning infrastructure across multiple clouds increases fault-tolerance, allowing for more graceful recovery from cloud provider outages. However, multi-cloud deployments add complexity because each provider has its own interfaces, tools, and workflows. Terraform lets you use the same workflow to manage multiple providers and handle cross-cloud dependencies. This simplifies management and orchestration for large-scale, multi-cloud infrastructures.


---  

## 2b	- Explain the benefits of state

During execution, Terraform will examine the state of the currently running infrastructure, determine what differences exist between the current state and the revised desired state, and indicate the necessary changes that must be applied. When approved to proceed, **only the necessary changes will be applied, leaving existing, valid infrastructure untouched**.

In addition to basic mapping, Terraform stores a cache of the attribute values for all resources in the state. This is the most optional feature of Terraform state and is done only as a **performance improvement**.