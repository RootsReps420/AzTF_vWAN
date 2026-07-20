# ---------------------------------------------------------------------------
# AVD Workspace + Application Groups
#
# Deploys an AVD Workspace, any number of Application Groups, and associates the
# app groups with the workspace.
#
# Names come from modules/naming (abbreviations vdw / vda — PENDING(TDA)
# sign-off, LLD Open Item 2; TDA defines no AVD codes yet).
# ---------------------------------------------------------------------------

module "workspace_name" {
  source = "../../naming"

  resource_type   = "avd_workspace"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

module "app_group_names" {
  source   = "../../naming"
  for_each = var.application_groups

  resource_type   = "avd_application_group"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = "${var.name}-${each.key}"
}

resource "azurerm_virtual_desktop_workspace" "this" {
  name                = module.workspace_name.name
  resource_group_name = var.resource_group_name
  location            = var.location
  friendly_name       = var.friendly_name
  description         = var.description
  tags                = var.tags
}

resource "azurerm_virtual_desktop_application_group" "this" {
  for_each = var.application_groups

  name                         = module.app_group_names[each.key].name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  host_pool_id                 = each.value.host_pool_id
  type                         = each.value.type
  friendly_name                = each.value.friendly_name
  description                  = each.value.description
  default_desktop_display_name = each.value.type == "Desktop" ? each.value.default_desktop_display_name : null
  tags                         = var.tags
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "this" {
  for_each = var.application_groups

  workspace_id         = azurerm_virtual_desktop_workspace.this.id
  application_group_id = azurerm_virtual_desktop_application_group.this[each.key].id
}
