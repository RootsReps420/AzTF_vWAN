# Basic example — a Premium FSLogix storage account with AADKERB auth and a
# single profiles share.

module "storage_fslogix" {
  source = "../.."

  name                = "lab01"
  resource_group_name = "rg-vdi-lab01-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  account_tier             = "Premium"
  account_kind             = "FileStorage"
  account_replication_type = "ZRS"

  azure_files_authentication = {
    directory_type = "AADKERB"
  }

  shares = {
    "profiles" = { quota_gb = 1024 }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "storage_account_name" {
  value = module.storage_fslogix.storage_account_name
}

output "file_share_names" {
  value = module.storage_fslogix.file_share_names
}
