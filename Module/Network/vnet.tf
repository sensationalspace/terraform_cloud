#######################################
#             NETWORKING              #
#######################################
resource "azurerm_virtual_network" "vnet" {
  name                = tostring(var.vnetName)
  address_space       = var.vnetAddressSpace
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = "staging"
  }
}

# resource "azurerm_subnet" "internal" {
#   name                 = "${var.prefix}-internal"
#   resource_group_name  = azurerm_resource_group.rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = var.snetAddressSpace#
# }
resource "azurerm_subnet" "workload" {
  name                              = var.snetName[0]
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.snetAddressSpace[0]
  private_endpoint_network_policies = var.networkPolicy
}

resource "azurerm_subnet" "endpoint" {
  name                              = var.snetName[1]
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.snetAddressSpace[1]
  private_endpoint_network_policies = var.networkPolicy
}
resource "azurerm_subnet" "bastion" {
  name                              = var.snetName[2]
  resource_group_name               = azurerm_resource_group.rg.name
  virtual_network_name              = azurerm_virtual_network.vnet.name
  address_prefixes                  = var.snetAddressSpace[2]
  private_endpoint_network_policies = var.networkPolicy
}