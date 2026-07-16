# modules/platform/hub-secured

Deploys **Hub01 — the Secured Virtual Hub** with Azure Firewall, ExpressRoute
Gateway, and Routing Intent. Used by PERS workloads.

## What it deploys

| Resource | Azure type |
|----------|-----------|
| Virtual Hub | `Microsoft.Network/virtualHubs` |
| Azure Firewall (`AZFW_Hub`) | `Microsoft.Network/azureFirewalls` |
| ExpressRoute Gateway | `Microsoft.Network/expressRouteGateways` |
| Routing Intent | `Microsoft.Network/virtualHubs/hubRoutingIntent` |
| Firewall Public IPs (auto-created) | `Microsoft.Network/publicIPAddresses` |

## Routing Intent

Routing Intent is enabled on this hub. **Internet** and **Private** traffic are
automatically routed through the Azure Firewall. As a result, **PERS spokes do
not require UDRs** — Azure programs the effective routes for connected spokes.

The `firewall_private_ip` output is still exposed for the rare case a spoke
needs an explicit UDR outside the routing-intent flow.

## Usage

```hcl
module "hub01" {
  source = "../../modules/platform/hub-secured"

  name                = "hub01"
  resource_group_name = "rg-connectivity-prod"
  location            = "uksouth"

  virtual_wan_id     = azurerm_virtual_wan.this.id
  address_prefix     = "10.0.0.0/23"
  firewall_policy_id = azurerm_firewall_policy.this.id

  express_route = {
    scale_units        = 2
    circuit_peering_id = azurerm_express_route_circuit_peering.private.id
  }

  tags = {
    environment = "prod"
    workload    = "PERS"
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | Base name for the hub resources | `string` | — |
| `resource_group_name` | Target resource group | `string` | — |
| `location` | Azure region | `string` | — |
| `virtual_wan_id` | Virtual WAN resource ID | `string` | — |
| `address_prefix` | Virtual hub CIDR (>= /24) | `string` | — |
| `hub_routing_preference` | `ExpressRoute` \| `VpnGateway` \| `ASPath` | `string` | `ExpressRoute` |
| `firewall_policy_id` | Firewall Policy resource ID | `string` | — |
| `firewall_sku_tier` | `Standard` \| `Premium` | `string` | `Standard` |
| `firewall_public_ip_count` | Firewall public IP count | `number` | `1` |
| `firewall_zones` | Firewall availability zones | `list(string)` | `["1","2","3"]` |
| `express_route` | ER gateway + circuit connection details | `object` | — |
| `tags` | Tags applied to all resources | `map(string)` | `{}` |

### `express_route` object

| Field | Description | Default |
|-------|-------------|---------|
| `scale_units` | ER gateway scale units (1-10) | `1` |
| `circuit_peering_id` | Circuit private peering ID to connect (optional) | `null` |
| `routing_weight` | ER connection routing weight | `0` |
| `authorization_key` | Auth key for cross-subscription circuits | `null` |

## Outputs

| Name | Description |
|------|-------------|
| `hub_id` | Virtual hub resource ID — consumed by spoke modules |
| `firewall_id` | Hub Azure Firewall resource ID |
| `firewall_private_ip` | Firewall private IP — for UDR configuration |
| `express_route_gateway_id` | ExpressRoute Gateway resource ID |
