# modules/core/keyvault

Deploys a **per-lab Key Vault** using the RBAC authorization model, with CMK
keys, secrets, and role assignments.

## Azure resources

- `azurerm_key_vault` (RBAC authorization, purge protection)
- `azurerm_key_vault_key` (per `keys` — CMKs)
- `azurerm_key_vault_secret` (per `secrets`)
- `azurerm_role_assignment` (per `role_assignments`, scoped to the vault by default)

## Naming

Uses the TDA Key Vault exception pattern `{region}-{env}-kvt-{id}` — pass the
7-char id via `unique_id`. Key Vault names are globally unique.

## Notes

- Role assignments are created before keys/secrets (`depends_on`) so the caller
  identity can perform data-plane operations under RBAC.
- `secrets` is marked sensitive.

## Outputs

`keyvault_id`, `keyvault_uri`, `keyvault_name`, `cmk_key_ids`.

See [`examples/basic`](examples/basic) for usage.
