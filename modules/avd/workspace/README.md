# modules/avd/workspace

Deploys an **AVD Workspace**, any number of **Application Groups**, and the
workspace ↔ app-group associations.

## Azure resources

- `azurerm_virtual_desktop_workspace`
- `azurerm_virtual_desktop_application_group` (per `application_groups`)
- `azurerm_virtual_desktop_workspace_application_group_association` (per group)

## Depends on

- `application_groups[*].host_pool_id` — output `hostpool_id` from
  `modules/avd/hostpool`

## Outputs

`workspace_id`, `workspace_name`, `app_group_ids`.

> Abbreviations `vdws` / `vdag` are PENDING TDA sign-off (LLD Open Item 2).

See [`examples/basic`](examples/basic) for usage.
