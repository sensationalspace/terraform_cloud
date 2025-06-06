resource "azurerm_network_security_group" "nsg-workload" {
  name                = "${azurerm_subnet.workload.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "InternetOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_network_security_group" "nsg-bastion" {
  name                = "${azurerm_subnet.bastion.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "sshRule"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "*"
    source_address_prefix      = "4.247.144.78"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "staging"
  }
}
resource "azurerm_network_security_group" "nsg-endpoint" {
  name                = "${azurerm_subnet.endpoint.name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsgSnet-w" {
  subnet_id                 = azurerm_subnet.workload.id 
  network_security_group_id = azurerm_network_security_group.nsg-workload.id
}

resource "azurerm_subnet_network_security_group_association" "nsgSnet-b" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.nsg-bastion.id
}

resource "azurerm_subnet_network_security_group_association" "nsgSnet-e" {
  subnet_id                 = azurerm_subnet.endpoint.id
  network_security_group_id = azurerm_network_security_group.nsg-endpoint.id
}