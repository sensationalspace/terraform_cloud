terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.59.0"
    }
  }
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
  skip_provider_registration = true

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
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

# Declare the Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup"
  location = "Central India"
}

# Declare the Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-VNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Declare the Subnet
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Generate a random suffix for uniqueness
resource "random_string" "storage_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Updated Storage Account with unique name
resource "azurerm_storage_account" "storage" {
  name                     = lower("${var.prefix}storacc${random_string.storage_suffix.result}")  # globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.internal.id]
  }
}


# Private Endpoint for the Storage Account
resource "azurerm_private_endpoint" "storage_pe" {
  name                = "${var.prefix}-storage-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.internal.id

  private_service_connection {
    name                           = "${var.prefix}-storage-psc"
    private_connection_resource_id = azurerm_storage_account.storage.id
    subresource_names              = ["blob"]  # Options: "blob", "file", etc.
    is_manual_connection           = false
  }
}

# Private DNS Zone for the Storage Account Blob endpoint
resource "azurerm_private_dns_zone" "storage_zone" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
}

# Link the DNS Zone to your Virtual Network for proper name resolution
resource "azurerm_private_dns_zone_virtual_network_link" "storage_zone_link" {
  name                  = "${var.prefix}-dnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
}
