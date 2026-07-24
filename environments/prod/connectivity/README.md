# environments/prod/connectivity

Connectivity subscription root for **prod** (legacy `prd`).

Same composition as `environments/int/connectivity` with prod address ranges from `params/prd/config.yml`.

```bash
terraform init -backend=false
terraform validate
```
