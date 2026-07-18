# ---------------------------------------------------------------------------
# Hub02 — Unsecured Virtual Hub
#
# Deploys an Unsecured Virtual Hub with a VPN Gateway. Used by MSH (multi-session
# host) workloads for internet egress via the Palo Alto Proxy. Unlike Hub01,
# this hub has no Azure Firewall and no Routing Intent — MSH spokes reach it via
# an explicit UDR (built in modules/core/spoke-msh).
#
# The VPN gateway's public IP addresses (Microsoft.Network/publicIPAddresses)
# are auto-created and managed by Azure as part of the gateway deployment.
#
# All resource names come from modules/naming — never hardcoded.
# ---------------------------------------------------------------------------

module "hub_name" {
  source = "../../naming"

  resource_type   = "virtual_hub"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

module "vpn_gateway_name" {
  source = "../../naming"

  resource_type   = "vpn_gateway"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

resource "azurerm_virtual_hub" "this" {
  name                   = module.hub_name.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  virtual_wan_id         = var.virtual_wan_id
  address_prefix         = var.address_prefix
  hub_routing_preference = var.hub_routing_preference
  tags                   = var.tags
}

resource "azurerm_vpn_gateway" "this" {
  name                = module.vpn_gateway_name.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = azurerm_virtual_hub.this.id
  scale_unit          = var.vpn.scale_unit
  routing_preference  = var.vpn.routing_preference
  tags                = var.tags

  dynamic "bgp_settings" {
    for_each = var.vpn.bgp_settings == null ? [] : [var.vpn.bgp_settings]
    content {
      asn         = bgp_settings.value.asn
      peer_weight = bgp_settings.value.peer_weight
    }
  }
}

# Diagnostic settings — stream VPN gateway logs and metrics to the platform Log
# Analytics workspace. Created only when a workspace id is supplied.
resource "azurerm_monitor_diagnostic_setting" "vpn_gateway" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-to-law"
  target_resource_id         = azurerm_vpn_gateway.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
