# Basic example — generate names for a few different resource types.

module "vnet_name" {
  source = "../.."

  resource_type   = "virtual_network"
  location        = "uksouth"
  subscription_id = "conn"
  environment     = "prod"
  description     = "hub01"
  unique_id       = "01"
}

module "keyvault_name" {
  source = "../.."

  resource_type   = "key_vault"
  location        = "uksouth"
  subscription_id = "vdi"
  environment     = "prod"
  description     = "core"
  unique_id       = "01"
}

module "storage_name" {
  source = "../.."

  resource_type   = "fslogix_storage_account"
  location        = "italynorth"
  subscription_id = "vdi"
  environment     = "dev"
  description     = "profiles"
}

output "vnet_name" {
  value = module.vnet_name.name
}

output "keyvault_name" {
  value = module.keyvault_name.name
}

output "storage_name" {
  value = module.storage_name.name
}
