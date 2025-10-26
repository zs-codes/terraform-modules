terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Specify your subscription ID
  subscription_id = "ea85166e-ff54-46a9-a1c8-9395a94988fc"
}

# Create a resource group for this example
resource "azurerm_resource_group" "demorg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "example"
    Purpose     = "storage-demo"
  }
}

# Basic storage account configuration
module "storage_account" {
  source = "../../"

  storage_account_name = var.storage_account_name
  resource_group_name  = azurerm_resource_group.demorg.name
  location             = azurerm_resource_group.demorg.location

  # Create a basic container
  containers = {
    "demo-container" = {
      access_type = "private"
      metadata = {
        purpose = "demo-data"
      }
    }
  }

  tags = {
    Environment = "development"
    Purpose     = "demo"
    Example     = "basic"
  }
}
