# environments/uksouth/dev

Region/environment root for **UK South (dev)**. Configuration only — variable
values plus module calls. All logic lives in `modules/`.

## Deploys

- **Connectivity platform**: firewall policy, Hub01 (secured), Hub02 (unsecured),
  management workspace (LAW + AVD Insights DCR)
- **PERS lab**: spoke (Hub01 only), Key Vault, FSLogix storage, personal host
  pool, workspace, personal scaling plan
- **MSH lab**: spoke (dual-hub + 3-rule UDR), pooled host pool, workspace
- **Images**: compute gallery + PERS and MSH base image definitions

The global Virtual WAN lives in [`environments/_global`](../../_global); pass its
`vwan_id` output into `var.virtual_wan_id`.

## Region agnostic

Everything is driven by `var.location`. To deploy another region, use that
region's root folder (e.g. `environments/italynorth/dev`) with the same module
calls — naming and tagging adapt automatically.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # then edit values

terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=sttfstatevdi" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=uksouth-dev.tfstate"

terraform plan
terraform apply
```

## Providers

Requires `azurerm`, `time`, and `azapi` (the last for AVD personal scaling
schedules).
