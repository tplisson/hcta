# HCTA Section 3 - Terraform basics

Section | Description |
------- | ----------- |  
**3**	| **Understand Terraform basics**
3a | Install and version Terraform providers
3b | Describe plugin-based architecture
3c | Write Terraform configuration using multiple providers
3d | Describe how Terraform finds and fetches providers

---  

## 3a	- Install and version Terraform providers

A provider configuration is created using a provider block:

```hcl
provider "google" {
  project = "acme-app"
  region  = "us-central1"
}
```

---  

## 3b	- Describe plugin-based architecture

Terraform relies on plugins called "providers" to interact with cloud providers, SaaS providers, and other APIs.

![Terraform Providers](../../images/tf-provider.webp)

Each provider adds a set of `resource` types and/or `data` sources that Terraform can manage.

---  

## 3c	- Write Terraform configuration using multiple providers

```hcl

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
    google {}
  }
}

# Configure the Amazon AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Configure the Google Cloud Platform Provider
provider "google" {
  project = "acme-app"
  region  = "us-central1"
}
```

---  

## 3d	- Describe how Terraform finds and fetches providers

The Terraform Registry is the main directory of publicly available Terraform providers, and hosts providers for most major infrastructure platforms.

Terraform Registry
https://registry.terraform.io/browse/providers

The core Terraform workflow consists of three stages:

Write: You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.
Plan: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
Apply: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.

---  
