resource "azurerm_network_interface" "nic" {
  name                = "${var.vmName}-nic" #"${var.prefix}-nic"
  location            = var.location        #azurerm_resource_group.rg.location
  resource_group_name = var.rgName          #azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = var.snetID #azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "staging"
  }
}
