# environments/int/labs

PERS + MSH spokes for **int**. Session hosts stay PowerShell.

## Verified INT CIDRs (legacy `config.yml`)

| Spoke | CIDR | Source |
|---|---|---|
| PERS 01a–01l | `10.170.140.0/28` … `10.170.140.176/28` | `net_lab_core_pers_01*_vnetAddressSpace` |
| MSH 01a | `10.170.141.0/24` (+ BU `/27`s) | `net_lab_core_mult_01a_*` |
| MSH 01b | `10.170.142.0/24` (+ BU subnets) | `net_lab_core_mult_01b_*` |

```bash
terraform init -backend=false
terraform validate
```
