# modules/platform/firewall-policy

Deploys the **Azure Firewall Policy** and its rule collection groups, plus any
**IP Groups** referenced by the rules. Firewall rules live here, not inline on
the firewall — the policy is the single source of truth and is attached to the
hub firewall (`modules/platform/hub-secured`) via `firewall_policy_id`.

## Azure resources

- `azurerm_firewall_policy`
- `azurerm_firewall_policy_rule_collection_group` (per group)
- `azurerm_ip_group` (per entry in `ip_groups`)

## Rule naming (TDA §10)

- Collections: `{allow|deny}-{environment}-{service}-{description}` (map key)
- Rules: `{inbound|outbound}-{description}` (map key)

## IP group references

Create IP groups in `ip_groups` (keyed by short name), then reference them from
rules with `source_ip_group_keys` / `destination_ip_group_keys`. The module
resolves the keys to the generated resource IDs — callers never handle IDs.

## Usage

See [`examples/basic`](examples/basic). Outputs `policy_id` (for hub-secured),
`policy_name`, and `ip_group_ids`.

## Inputs (summary)

| Name | Type | Default |
|------|------|---------|
| `name` | `string` | — |
| `resource_group_name` | `string` | — |
| `location` | `string` | — |
| `subscription_id` | `string` | — |
| `environment` | `string` | — |
| `unique_id` | `string` | `""` |
| `sku` | `string` | `"Standard"` |
| `threat_intelligence_mode` | `string` | `"Alert"` |
| `dns` | `object` | `null` |
| `ip_groups` | `map(object)` | `{}` |
| `rule_collection_groups` | `map(object)` | `{}` |
| `tags` | `map(string)` | `{}` |
