# Address plan notes (connectivity hubs)

Cross-checked against `legacy/platform/vdi-platform/params/{int,prd,ppd}/config.yml` and `legacy/pers/vdi-core-pers/params/{int,prd}/config.yml`.

Hub prefixes must be **unique across environments** if they share a corporate routing domain (classic pattern: INT=245, PPD=246, PRD=247).

## Verified Hub01 (classic → vWAN `address_prefix`)

| Env | Legacy key | CIDR | TF status |
|---|---|---|---|
| int | `net_hub_01_vnetAddressSpace` | `10.170.245.0/24` | **Used** |
| prod | `net_hub_01_vnetAddressSpace` | `10.170.247.0/24` | **Used** |
| ppd (retired) | `net_hub_01_vnetAddressSpace` | `10.170.246.0/24` | Reclaimed for INT Hub02 |

Classic FW PIP / `/26` FW / FW-mgmt / ER slices of the hub `/24` are **not** recreated as VNet subnets under vWAN (hub SKUs attach AZFW + ER GW).

DNS (both envs): `10.19.96.1`, `10.19.97.1` (`p_dnsServers`) — **Used**.

## Hub02 (new — accepted as TF defaults)

Formal network sign-off deferred; defaults below are treated as **OK for code** until superseded.

| Env | CIDR | Why |
|---|---|---|
| int | `10.170.246.0/24` | Unused in int allocations; was PPD Hub01 (ppd dropped). Inside int `net_superNetCidr` `10.170.128.0/17`. |
| prod | `10.170.244.0/24` | Unused in legacy configs searched. Distinct from INT Hub02 and both Hub01s. |

### Rejected / do not use

| CIDR | Why |
|---|---|
| `10.170.248.0/24` as prod Hub02 | **Collides** with prod `net_lab_core_pers_01l` = `10.170.248.0/21` |
| `10.170.246.0/24` for **both** int and prod Hub02 | Breaks cross-env uniqueness |
| `10.170.245.0/24` as prod Hub02 | Is live INT Hub01 |

## Verified spokes (selected)

| Env | Resource | CIDR | Source |
|---|---|---|---|
| int | mgmt | `10.170.139.192/26` | `net_mgmt_*` |
| int | PERS 01a–01l | `10.170.140.{0,16,…,176}/28` | pers `config.yml` |
| int | MSH 01a / 01b | `10.170.141.0/24`, `10.170.142.0/24` + named `/27`–`/25` subnets | pers `config.yml` |
| prod | mgmt | `10.170.241.64/26` | `net_mgmt_*` |
| prod | PERS 01a–01l | `/21`/`/22`/`/27` map from platform `prd/config.yml` | verified |
| prod | MSH 01a / 01b | `10.218.16.0/21`, `10.218.24.0/21` + named subnets | pers `prd/config.yml` |

## Classic → vWAN mapping

Under Azure Virtual WAN, Hub01 is a **virtual hub** with `address_prefix` = legacy hub VNet CIDR.  
`AzureFirewallSubnet`, `AzureFirewallManagementSubnet`, and `GatewaySubnet` from the classic hub VNet are **not** modelled as spoke/hub VNet subnets — firewall and ER gateway are attached as hub SKUs (`AZFW_Hub`, ER GW).
