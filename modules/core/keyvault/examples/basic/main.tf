# Basic example — a per-lab Key Vault with a CMK and an admin role assignment.

data "azurerm_client_config" "current" {}

module "keyvault" {
  source = "../.."

  name                = "lab01"
  resource_group_name = "rg-vdi-lab01-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "lab01a1"

  purge_protection_enabled      = true
  public_network_access_enabled = false

  keys = {
    "cmk-fslogix" = {
      key_type = "RSA"
      key_size = 2048
      key_opts = ["unwrapKey", "wrapKey"]
    }
  }

  role_assignments = {
    "kv-admin" = {
      role_definition_name = "Key Vault Administrator"
      principal_id         = data.azurerm_client_config.current.object_id
    }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "keyvault_id" {
  value = module.keyvault.keyvault_id
}

output "cmk_key_ids" {
  value = module.keyvault.cmk_key_ids
}
