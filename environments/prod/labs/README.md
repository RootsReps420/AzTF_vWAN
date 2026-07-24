# environments/prod/labs

PERS + MSH spokes for **prod**. Session hosts stay PowerShell.

## Verified PROD CIDRs (legacy `config.yml`)

| Spoke | CIDR | Source |
|---|---|---|
| PERS 01a–01h, 01k | `/21` from `10.170.160.0` … `10.170.232.0` | platform `prd/config.yml` |
| PERS 01i | `10.170.224.0/22` | Robotics |
| PERS 01j | `10.170.241.0/27` | P&D (adjacent to mgmt `241.64/26`) |
| PERS 01l | `10.170.248.0/21` | **blocks** Hub02 using `248/24` |
| MSH 01a | `10.218.16.0/21` (+ named `/24`/`/26`s) | pers `prd/config.yml` |
| MSH 01b | `10.218.24.0/21` (+ named subnets) | pers `prd/config.yml` |

```bash
terraform init -backend=false
terraform validate
```
