terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0" # 4.x required: code uses 4.x-only args (rbac_authorization_enabled, https_traffic_only_enabled, enabled_metric)
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 2.0.0, < 3.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9.0"
    }
  }

  # Remote state in Azure Storage. Partial config — supply the backend values
  # at init time, e.g.:
  #   terraform init \
  #     -backend-config="resource_group_name=rg-tfstate" \
  #     -backend-config="storage_account_name=sttfstatevdi" \
  #     -backend-config="container_name=tfstate" \
  #     -backend-config="key=uksouth-prod.tfstate"
  backend "azurerm" {}
}

provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
}

provider "azapi" {
  subscription_id = var.azure_subscription_id
}
