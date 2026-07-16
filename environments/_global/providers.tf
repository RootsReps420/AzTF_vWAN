terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0, < 5.0.0"
    }
  }

  # Remote state in Azure Storage. Partial config — supply the backend values
  # at init time, e.g.:
  #   terraform init \
  #     -backend-config="resource_group_name=rg-tfstate" \
  #     -backend-config="storage_account_name=sttfstatevdi" \
  #     -backend-config="container_name=tfstate" \
  #     -backend-config="key=_global.tfstate"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}
