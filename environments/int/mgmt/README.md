# environments/int/mgmt

LAW + mgmt spoke for **int** (DT). Agent VMSS stays PowerShell.

| Item | CIDR | Source |
|---|---|---|
| Mgmt VNet / AgentsSubnet | `10.170.139.192/26` | VERIFIED `net_mgmt_*` in `params/int/config.yml` |

```bash
terraform init -backend=false
terraform validate
```
