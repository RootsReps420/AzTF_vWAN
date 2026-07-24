# environments/prod/mgmt

LAW + mgmt spoke for **prod** (legacy prd). Agent VMSS stays PowerShell.

| Item | CIDR | Source |
|---|---|---|
| Mgmt VNet / AgentsSubnet | `10.170.241.64/26` | VERIFIED `net_mgmt_*` in `params/prd/config.yml` |

```bash
terraform init -backend=false
terraform validate
```
