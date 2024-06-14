# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      # Specifies the source of the azurerm provider
      source = "hashicorp/azurerm"
      # Specifies the minimum version of the azurerm provider
      version = ">= 3.59.0"
    }
  }
  # Specifies the minimum version of Terraform required
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}

  # Skips provider registration, which can speed up the apply process
  skip_provider_registration = "true"

  # Connection to Azure using service principal credentials
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Variable to define a prefix for resource naming
variable "prefix" {
  default = "terraform"
}

# Variable to store Azure service principal client ID
variable "client_id" {
  type = string
}

# Variable to store Azure service principal client secret
variable "client_secret" {
  type = string
}

# Variable to store Azure subscription ID
variable "subscription_id" {
  type = string
}

# Variable to store Azure tenant ID
variable "tenant_id" {
  type = string
}

# Resource group definition
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup"
  location = "Central India"
}

# Virtual network definition
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet definition
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network interface definition
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


# Virtual machine definition
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  # OS image definition
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  # OS disk definition
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # OS profile definition
  os_profile {
    computer_name  = "hostname"
    admin_username = "tfadmin"
    admin_password = "Password1234!"
  }

  # Linux-specific OS profile configuration
  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Tags for the virtual machine
  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "examplestorageacct" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}




