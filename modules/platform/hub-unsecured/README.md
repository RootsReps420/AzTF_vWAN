# modules/platform/hub-unsecured

Deploys **Hub02 — the Unsecured Virtual Hub** with a VPN Gateway. Used by **MSH
(multi-session host)** workloads for internet egress via the Palo Alto Proxy.

Unlike `hub-secured` (Hub01), this hub has **no Azure Firewall and no Routing
Intent**. MSH spokes reach it via an explicit UDR built in
`modules/core/spoke-msh`.

## Azure resources

- `azurerm_virtual_hub`
- `azurerm_vpn_gateway` (public IPs auto-created by Azure)
- `azurerm_monitor_diagnostic_setting` (when `log_analytics_workspace_id` set)

## Depends on

- Virtual WAN ID from `modules/platform/vwan` (`vwan_id`)

## Outputs

- `hub_id` — consumed by MSH spoke modules
- `vpn_gateway_id` — consumed by MSH spoke modules for internet egress
- `hub_name`

> Open Item 5: Palo Alto Proxy VPN endpoint availability must be confirmed by the
> network team before real MSH egress values are wired.

See [`examples/basic`](examples/basic) for usage.
