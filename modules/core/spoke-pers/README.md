# modules/core/spoke-pers

Deploys a **PERS (personal desktop) workload spoke**. Connects to **Hub01 only**.
Hub01 Routing Intent handles all egress, so this spoke needs **no user-defined
routes**.

## Azure resources

- `azurerm_virtual_network`
- `azurerm_subnet` (per `subnets`)
- `azurerm_network_security_group` + association (per subnet)
- `azurerm_network_watcher` (when `create_network_watcher`)
- `azurerm_virtual_hub_connection` (to Hub01)

## Depends on

- `hub01_id` — output `hub_id` from `modules/platform/hub-secured`

## Outputs

- `vnet_id`, `vnet_name`
- `subnet_ids` — consumed by AVD / Key Vault / storage modules
- `nsg_ids`, `hub_connection_id`

See [`examples/basic`](examples/basic) for usage.
