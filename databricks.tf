provider "azurerm" {
  features {}
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.example.id
  azure_client_id             = var.azure_client_id
  azure_client_secret         = var.azure_client_secret
  azure_tenant_id             = var.azure_tenant_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West Europe"
}

resource "azurerm_databricks_workspace" "example" {
  name                = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
}

resource "databricks_cluster" "example" {
  cluster_name            = "example-cluster"
  spark_version           = "7.3.x-scala2.12"
  node_type_id            = "Standard_D3_v2"
  autotermination_minutes = 30

  autoscale {
    min_workers = 1
    max_workers = 3
  }

  azure_attributes {
    availability     = "ON_DEMAND_AZURE"
    first_on_demand  = 1
    spot_bid_max_price = -1
  }
}

output "databricks_cluster_id" {
  value = databricks_cluster.example.id
}
