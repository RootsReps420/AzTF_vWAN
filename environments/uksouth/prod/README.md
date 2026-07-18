# environments/uksouth/prod

Region/environment root for **UK South (prod)**. Configuration only — variable
values plus module calls. All logic lives in `modules/`.

Identical composition to [`../dev`](../dev) with production values (longer LAW
retention, prod address plan). See that README for the full deploy list.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars   # then edit values

terraform init \
  -backend-config="resource_group_name=rg-tfstate" \
  -backend-config="storage_account_name=sttfstatevdi" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=uksouth-prod.tfstate"

terraform plan
terraform apply
```

## Providers

Requires `azurerm`, `time`, and `azapi` (the last for AVD personal scaling
schedules).
