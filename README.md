
# Databricks Cluster Setup with Terraform

## Overview

Welcome to the Terraform test for the DevOps engineer position. The goal of this test is to assess your ability to create and manage infrastructure using Terraform, specifically focused on setting up a Databricks environment on Azure.

## Objective

Your task is to enhance the existing Terraform configuration by adding a Databricks cluster setup. You will be working within an existing Terraform project and pushing your changes to a GitHub repository, which will trigger a Terraform Cloud workflow.

## Prerequisites

- Terraform environment setup in Terraform Cloud.
- Azure subscription with necessary permissions.
- GitHub repository with initial Terraform scripts.
- Codespaces or local Visual Studio Code environment.

## Instructions

1. **Clone the Repository**:
   - Fork the provided GitHub repository to your GitHub account.
   - Clone the forked repository to your local environment or open it in GitHub Codespaces.

2. **Set Up Azure Credentials**:
   - Ensure Azure credentials are configured correctly. Use the following command to log in if necessary:
     ```sh
     az login
     ```

3. **Task: Modify Terraform Scripts**:
   - Navigate to the `terraform` directory in the repository.
   - Add the necessary Terraform configuration to create a Databricks cluster within the existing Databricks workspace.
   - Ensure the cluster has the following specifications:
     - **Cluster name**: `example-cluster`
     - **Node type**: `Standard_D3_v2`
     - **Autoscaling**: Enabled, with min nodes 1 and max nodes 3
     - **Auto-termination**: After 30 minutes of inactivity

4. **Test the Configuration**:
   - Ensure the Terraform configuration is valid by running:
     ```sh
     terraform fmt
     terraform validate
     ```

5. **Commit and Push**:
   - Commit your changes to your forked repository.
   - Push the changes to trigger the Terraform Cloud workflow.

6. **Submission**:
   - Once completed, submit the link to your forked repository for review.

## Example Terraform Script

Here is an example `main.tf` to guide you:

```hcl
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

Once you have completed the tasks, commit your changes to your forked repository and push them. Share the link to your repository with us for review.
