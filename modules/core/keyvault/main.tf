# ---------------------------------------------------------------------------
# Core — Key Vault (per lab)
#
# Deploys a per-lab Key Vault (RBAC authorization model) with:
#   - CMK keys (map-driven)
#   - Secrets (map-driven)
#   - RBAC role assignments (map-driven, scoped to the vault by default)
#
# The Key Vault name uses the TDA Key Vault exception pattern
# ({region}-{env}-kvt-{id}) via modules/naming.
# ---------------------------------------------------------------------------

data "azurerm_client_config" "current" {}

module "kv_name" {
  source = "../../naming"

  resource_type   = "key_vault"
  location        = var.location
  environment     = var.environment
  subscription_id = var.subscription_id
  description     = var.name
  unique_id       = var.unique_id
}

resource "azurerm_key_vault" "this" {
  name                = module.kv_name.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
  sku_name            = var.sku_name

  rbac_authorization_enabled    = true
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = var.soft_delete_retention_days
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "network_acls" {
    for_each = var.network_acls == null ? [] : [var.network_acls]
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

# RBAC assignments — created first so key/secret operations by the caller
# identity succeed when data-plane RBAC is required.
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                = coalesce(each.value.scope, azurerm_key_vault.this.id)
  role_definition_name = each.value.role_definition_name
  principal_id         = each.value.principal_id
}

resource "azurerm_key_vault_key" "this" {
  for_each = var.keys

  name         = each.key
  key_vault_id = azurerm_key_vault.this.id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  curve        = each.value.curve
  key_opts     = each.value.key_opts

  dynamic "rotation_policy" {
    for_each = each.value.rotation_policy == null ? [] : [each.value.rotation_policy]
    content {
      expire_after         = rotation_policy.value.expire_after
      notify_before_expiry = rotation_policy.value.notify_before_expiry
      automatic {
        time_before_expiry = rotation_policy.value.time_before_expiry
      }
    }
  }

  depends_on = [azurerm_role_assignment.this]
}

resource "azurerm_key_vault_secret" "this" {
  for_each = var.secrets

  name         = each.key
  value        = each.value
  key_vault_id = azurerm_key_vault.this.id

  depends_on = [azurerm_role_assignment.this]
}
