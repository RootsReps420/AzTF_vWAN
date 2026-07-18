# Basic example — a workspace with a desktop application group backed by a host
# pool.

module "workspace" {
  source = "../.."

  name                = "vdi-fin"
  resource_group_name = "rg-vdi-fin-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  friendly_name = "Finance VDI"

  application_groups = {
    "desktop" = {
      host_pool_id                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-vdi-fin-dev/providers/Microsoft.DesktopVirtualization/hostPools/uks-vdi-vdhp-mult-fin-01"
      type                         = "Desktop"
      friendly_name                = "Finance Desktop"
      default_desktop_display_name = "Finance"
    }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-mult"
    repo         = "vdi-terraform"
  }
}

output "workspace_id" {
  value = module.workspace.workspace_id
}
