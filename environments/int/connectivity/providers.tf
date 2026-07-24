terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }

  # Partial backend — supply at init:
  #   terraform init -backend-config="key=int-connectivity.tfstate" ...
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
}
