#######################################
#         RESOURCE GROUP              #
#######################################
resource "azurerm_resource_group" "rg" {
  name     = var.rgName#"${var.prefix}-resourcegroup"
  location = var.rgLocation#"Central India"
  
  tags = {
    environment = "staging"
  }
}