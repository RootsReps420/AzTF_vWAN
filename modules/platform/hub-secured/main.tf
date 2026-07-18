# ---------------------------------------------------------------------------
# Hub01 — Secured Virtual Hub
#
# Deploys a Secured Virtual Hub with:
#   - Virtual Hub attached to the Virtual WAN
#   - Azure Firewall (AZFW_Hub SKU) governed by the supplied Firewall Policy
#   - ExpressRoute Gateway (+ optional circuit connection)
#   - Routing Intent: Internet and Private traffic routed via Azure Firewall
#   - Diagnostic settings on the firewall -> Log Analytics (when law id supplied)
#
# Because Routing Intent is enabled, PERS spokes attached to this hub do NOT
# need user-defined routes — Azure programs the routing automatically.
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

module "firewall_name" {
  source = "../../naming"

  resource_type   = "azure_firewall"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

module "ergw_name" {
  source = "../../naming"

  resource_type   = "expressroute_gateway"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

module "erconn_name" {
  source = "../../naming"

  resource_type   = "expressroute_connection"
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

# Azure Firewall deployed into the virtual hub (AZFW_Hub SKU). The public IP
# addresses (Microsoft.Network/publicIPAddresses) are auto-created by Azure
# based on public_ip_count.
resource "azurerm_firewall" "this" {
  name                = module.firewall_name.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = "AZFW_Hub"
  sku_tier            = var.firewall_sku_tier
  firewall_policy_id  = var.firewall_policy_id
  zones               = length(var.firewall_zones) > 0 ? var.firewall_zones : null
  tags                = var.tags

  virtual_hub {
    virtual_hub_id  = azurerm_virtual_hub.this.id
    public_ip_count = var.firewall_public_ip_count
  }
}

# ExpressRoute Gateway attached to the hub.
resource "azurerm_express_route_gateway" "this" {
  name                = module.ergw_name.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = azurerm_virtual_hub.this.id
  scale_units         = var.express_route.scale_units
  tags                = var.tags
}

# Optional connection from the ER gateway to a circuit's private peering.
resource "azurerm_express_route_connection" "this" {
  count = var.express_route.circuit_peering_id != null ? 1 : 0

  name                             = module.erconn_name.name
  express_route_gateway_id         = azurerm_express_route_gateway.this.id
  express_route_circuit_peering_id = var.express_route.circuit_peering_id
  routing_weight                   = var.express_route.routing_weight
  authorization_key                = var.express_route.authorization_key
}

# Routing Intent — routes Internet and Private traffic through Azure Firewall.
# This is what makes the hub "secured" and removes the need for spoke UDRs.
# No TDA abbreviation exists for routing intent, so the name is derived directly.
resource "azurerm_virtual_hub_routing_intent" "this" {
  name           = "ri-${var.name}"
  virtual_hub_id = azurerm_virtual_hub.this.id

  routing_policy {
    name         = "InternetTraffic"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.this.id
  }

  routing_policy {
    name         = "PrivateTrafficPolicy"
    destinations = ["PrivateTraffic"]
    next_hop     = azurerm_firewall.this.id
  }
}

# Diagnostic settings — stream firewall logs and metrics to the platform Log
# Analytics workspace. Created only when a workspace id is supplied.
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  name                       = "diag-to-law"
  target_resource_id         = azurerm_firewall.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
