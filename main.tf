#######################################
#            TERRAFORM BLOCK          #
#######################################
terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

#######################################
#            PROVIDER BLOCK           #
#######################################
provider "azurerm" {
  features {}

  # Service-principal creds
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  # Disable automatic RP registration (new way)
  resource_provider_registrations = "none"
}

#######################################
#              VARIABLES              #
#######################################
variable "prefix" {
  description = "Prefix used for all resources"
  type        = string
  default     = "terra"
}

variable "client_id"       { type = string }
variable "client_secret"   { type = string }
variable "subscription_id" { type = string }
variable "tenant_id"       { type = string }

#######################################
#        RANDOM SUFFIX FOR SA         #
#######################################
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

#######################################
#               LOCALS                #
#######################################
locals {
  # Storage account: 3–24 chars, lowercase letters & digits only
  storage_account_name = "${var.prefix}vishalstorage${random_string.suffix.result}"
  container_name       = "${var.prefix}-vishal-container"
  blob_name            = "${var.prefix}-vishal-blob-storage"
}

#######################################
#         RESOURCE GROUP              #
#######################################
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resourcegroup"
  location = "Central India"
}

#######################################
#             NETWORKING              #
#######################################
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
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
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

#######################################
#              STORAGE                #
#######################################
resource "azurerm_storage_account" "blob_storage" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "blob_storage" {
  name                  = local.container_name
  storage_account_id    = azurerm_storage_account.blob_storage.id
  container_access_type = "private"
}

resource "azurerm_storage_blob" "blob_storage" {
  name                   = local.blob_name
  storage_account_name   = azurerm_storage_account.blob_storage.name
  storage_container_name = azurerm_storage_container.blob_storage.name
  type                   = "Block"
  source                 = "some-local-file.zip"
}

#######################################
#          VIRTUAL MACHINE            #
#######################################
resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
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
