# modules/naming

Implements the **TDA ARN Naming Standard v2**. A pure-computation module (no
Azure resources) that turns a resource type + context into a bank-compliant
resource name. **Every other module calls this** — names are never hardcoded.

## Behaviour

- Resolves the bank **abbreviation** for the given `resource_type`.
- Resolves the **region short code** for the given `location`.
- Selects the correct **naming pattern** for the resource family:

| Family | Pattern | Notes |
|--------|---------|-------|
| Default | `{abbr}-{sub}-{desc}-{env}-{region}-{uid}` | hyphenated |
| Storage Account (`storage_account`, `fslogix_storage_account`) | `{abbr}{sub}{desc}{env}{region}{uid}` | lowercased, alphanumeric only, ≤ 24 chars |
| Key Vault (`key_vault`) | `{abbr}-{sub}-{desc}-{env}-{region}-{uid}` | lowercased, ≤ 24 chars |
| Managed Identity (`managed_identity`) | `{abbr}-{sub}-{desc}-{env}-{region}` | no unique-id segment |

- **Fails `terraform plan`** with a clear, enumerated error if an unknown
  `resource_type` or `location` is passed (via `terraform_data` preconditions).

Empty segments (e.g. an omitted `unique_id`) are dropped, so no double hyphens.

## Abbreviations

| Slug (`resource_type`) | Abbr | Slug | Abbr |
|---|---|---|---|
| `virtual_wan` | `vwn` | `key_vault` | `kvt` |
| `virtual_hub` | `vhb` | `storage_account` | `sta` |
| `virtual_hub_connection` | `vhc` | `fslogix_storage_account` | `fsa` |
| `azure_firewall` | `afw` | `log_analytics_workspace` | `law` |
| `firewall_policy` | `fwp` | `action_group` | `mag` |
| `expressroute_gateway` | `erg` | `metric_alert` | `maa` |
| `vpn_gateway` | `vpg` | `log_alert` | `mma` |
| `virtual_network` | `net` | `defender_for_cloud` | `mdc` |
| `network_security_group` | `nsg` | `compute_gallery` | `gal` |
| `route_table` | `rte` | `image_definition` | `img` |
| `network_watcher` | `ntw` | `managed_identity` | `msi` |
| `resource_group` | `rsg` | `public_ip` | `pip` |
| `application_security_group` | `asg` | | |

> The abbreviation → meaning mapping for `mag` / `maa` / `mma` (monitoring
> resources) should be confirmed against the authoritative TDA ARN v2 document;
> adjust the `abbreviations` map in `main.tf` if the source standard differs.

### Regions

`uksouth`→`uks`, `ukwest`→`ukw`, `italynorth`→`itn`, `spaincentral`→`spc`,
`northeurope`→`neu`, `westeurope`→`weu`.

## Usage

```hcl
module "vnet_name" {
  source = "../../naming"

  resource_type   = "virtual_network"
  location        = "uksouth"
  subscription_id = "conn"
  environment     = "prod"
  description     = "hub01"
  unique_id       = "01"
}

# module.vnet_name.name         => "net-conn-hub01-prod-uks-01"
# module.vnet_name.abbreviation => "net"
# module.vnet_name.region_short => "uks"
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `resource_type` | Resource-type slug to name | `string` | — |
| `location` | Azure region | `string` | — |
| `subscription_id` | Short subscription / landing-zone code | `string` | — |
| `environment` | Environment segment (`dev`/`prod`) | `string` | — |
| `description` | Short workload/purpose descriptor | `string` | — |
| `unique_id` | Optional instance suffix | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| `name` | Bank-compliant resource name |
| `abbreviation` | Resolved bank abbreviation |
| `region_short` | Resolved region short code |
