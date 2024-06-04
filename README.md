
# Storage Setup with Terraform

## Overview

Welcome to the Terraform test for the DevOps engineer position. The goal of this test is to assess your ability to create and manage infrastructure using Terraform, specifically focused on setting up a Databricks environment on Azure.

## Objective

Your task is to enhance the existing Terraform configuration by adding a Storage setup. You will be working within an existing Terraform project and pushing your changes to a GitHub repository, which will trigger a Terraform Cloud workflow.

## Prerequisites

- GitHub Account.
- Visual Studio Code.
- Terraform installed.
- Knowledge of Terraform code and GitHub.

## Instructions

1. **Clone the Repository**:
   - Fork the provided GitHub repository to your GitHub account.
   - Clone the forked repository to your local environment or open it in GitHub Codespaces.


2. **Task: Modify Terraform Scripts**:
   - Navigate to the `terraform` directory in the repository.
   - Add the necessary Terraform configuration to create an Azure Blob Storage account.
   - Ensure the Blob Storage account has the following specifications:
     - **Storage account name**: `examplestorageacct`
     - **Resource group**: Specify the existing resource group or create a new one if needed.
     - **Location**: Choose an appropriate Azure region, e.g., `West Europe`
     - **SKU**: `Standard_LRS`
     - **Kind**: `StorageV2`
     - **Access tier**: `Hot`


3. **Test the Configuration**:
   - Ensure the Terraform configuration is valid by running:
     ```sh
     terraform fmt
     terraform validate
     ```

4. **Commit and Push**:
   - Commit your changes to your forked repository.
   - Push the changes to trigger the Terraform Cloud workflow.

5. **Submission**:
   - Once completed, submit the link to your forked repository for review.

## Example Terraform Script

Here is an example `main.tf` to guide you:

```hcl
# Configure Azure Provider
terraform {
  required_providers {
     azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 3.59.0"
    } 
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  skip_provider_registration = "true"
  
  # Connection to Azure
  subscription_id = var.subscription_id
  client_id = var.client_id
  client_secret = var.client_secret
  tenant_id = var.tenant_id
}

variable "prefix" {
  default = "terraform"
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup"
  location = "Central India"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "tfconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "tfadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

```

## Review Criteria

1. **Correctness**: Verify the Terraform plan runs successfully without errors. Ensure the Databricks cluster is configured correctly as per the specifications.
2. **Code Quality**: The code should follow Terraform best practices and be well-organized.
3. **Documentation**: The `README.md` file should clearly explain the setup process and any assumptions or requirements.
4. **Version Control**: The commit history should show logical, well-documented changes.

## Notes

- Ensure that your Azure credentials are correctly configured in Terraform Cloud.
- The configuration is idempotent and can be applied multiple times without creating duplicate resources.
- If you encounter any issues, check the Terraform logs and ensure your Azure environment is correctly set up.

## Submission

Once you have completed the tasks, commit your changes to your forked repository and push them. Then run the Plan in Terraform Cloud if successful your done otherwise update the code and repeat
