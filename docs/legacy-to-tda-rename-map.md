# Legacy → TDA rename map (Phase A)

All Terraform-managed resources use **TDA naming** via `modules/naming`.  
This map drives Packer/pipeline/param string updates (Phase F/H). Session-host
VM hostnames (e.g. `MSH005010001`) are **out of scope** (stay PS).

Env placeholder: legacy `EEE` / `{env}` → `idv` | `ici` | `itt` | `int` | `prd`→`prod` (drop `ppd`).  
AVD abbreviations in naming module: `vdh` (host pool), `vdw` (workspace), `vda` (app group), `vds` (scaling plan).

---

## Pattern summary

| Resource | Legacy pattern | TDA pattern (via naming module) |
|---|---|---|
| Host pool (MSH) | `uks-{env}-vdi-avd-hpl-mult-{bu}-{pool}` | `{region}-{sub}-vdh-{desc}` e.g. `uks-vdi-vdh-mult-{bu}-{pool}` |
| Scaling plan (MSH) | `uks-{env}-vdi-avd-sp-mult-{bu}-{pool}` (+ `-decom`) | `{region}-{sub}-vds-mult-{bu}-{pool}` (+ `-decom`) |
| Host pool (PERS) | `uks-{env}-vdi-avd-hpl-*` | `{region}-{sub}-vdh-{persona}` |
| Workspace | `uks-{env}-vdi-avd-ws-*` | `{region}-{sub}-vdw-{desc}` |
| App group | `uks-{env}-vdi-avd-ag-*` | `{region}-{sub}-vda-{desc}` |
| Gallery | `uks{env}vdiavdgal01` | underscore gallery name from naming (Azure exception) |
| Image definition | `img-windows-...` / `uks-img-...` | TDA `img` abbr + description (see gallery section) |
| Key vault | legacy KV names in avd/lab | `{region}-{env}-{service}-kvt-{7char}` |
| Resource group | `uks-{env}-vdi-*-rsg` | `{region}-{sub}-rsg-{desc}` |
| VNet (spoke) | lab VNet names from labCore* | `{region}-{sub}-net-{desc}` |
| Firewall / policy | hub FW names | `{region}-{sub}-afw-*` / `fwp-*` |
| Virtual WAN / hub | n/a (new) | `vwn` / `vhb` |

Exact strings are produced by `modules/naming` at apply time — use module outputs in scripts, do not hardcode.

---

## MSH host pools & scaling plans

Legacy files: `legacy/mult/vdi-mult/params/hostpools/uks-EEE-vdi-avd-hpl-mult-{BU}-{pool}.json`  
BUs: `001`–`009`, `999`. Pools: `00` (canary), `01`, `02`.

| Legacy host pool | Legacy scaling plan | Legacy decom SP | Notes |
|---|---|---|---|
| `uks-{env}-vdi-avd-hpl-mult-{bu}-{pool}` | `uks-{env}-vdi-avd-sp-mult-{bu}-{pool}` | `...-sp-mult-{bu}-{pool}-decom` | One SP + decom per pool |
| e.g. `uks-int-vdi-avd-hpl-mult-005-01` | `uks-int-vdi-avd-sp-mult-005-01` | `...-005-01-decom` | BU 005 uses `*_005` schedules |
| e.g. `uks-int-vdi-avd-hpl-mult-001-00` | `uks-int-vdi-avd-sp-mult-001-00` | `...-001-00-decom` | Canary uses `*_canary` |

**TF description segment suggestion:** `mult-{bu}-{pool}` → naming yields `uks-vdi-vdh-mult-005-01` (env may be in subscription/env segment depending on call site).

Update all references in: `vdi-mult` params/scripts, alerts that embed SP names, placement maps.

---

## PERS host pools / workspaces / scaling

| Legacy | TDA |
|---|---|
| `uks-{env}-vdi-avd-hpl-{persona}` | `{region}-{sub}-vdh-{persona}` |
| `uks-{env}-vdi-avd-ws-*` | `{region}-{sub}-vdw-*` |
| `uks-{env}-vdi-avd-sp-*` (personal, hpl→sp rename) | `{region}-{sub}-vds-*` |

Source: `vdi-scripts` `New-VDIAVDHostpool` / `AVD-ScalingPlans.json`.  
Build exact map during Phase E from live inventory of PERS pool names.

---

## Gallery & image definitions

| Legacy | Example (`int`) | TDA direction |
|---|---|---|
| Gallery name | `uksintvdiavdgal01` | Naming module gallery pattern (underscore) |
| Gallery RG | `uks-int-vdi-avd-gallery-images-rsg` | `{region}-{sub}-rsg-gallery-images` |
| Image defs | `img-windows-desktop-11-gen2-...` in `configSets.json` | Keep semantic suffix; wrap with TDA `img` naming — **confirm** whether Azure image definition names stay as-is (gallery-scoped) or get TDA rename |

Packer `.pkr.hcl` and `Images_CreateInputVariablesJSON.ps1` must point at new gallery + definition names after Phase F.

---

## Platform / connectivity (new vWAN names)

| Role | Legacy (classic hub) | TDA (vWAN) |
|---|---|---|
| Virtual WAN | n/a | `{region}-{sub}-vwn-*` via `platform/vwan` |
| Secured hub | Hub VNet + AZFW | `{region}-{sub}-vhb-hub01` + `afw` / `fwp` / `erg` |
| Unsecured hub | n/a | `{region}-{sub}-vhb-hub02` + `vpg` |
| Mgmt VNet | `uks-{env}-vdi-mgmt-*` | `{region}-{sub}-net-mgmt` |
| LAW | legacy LAW name | `{region}-{sub}-law-*` |

IP ranges stay **verbatim** from `config.yml` — only names/mechanism change.

---

## Key vaults

| Legacy context | TDA |
|---|---|
| AVD-sub KV (`bicep/avd/rsg_keyvault`) | `{region}-{env}-{service}-kvt-{7char}` |
| Lab / packaging KVs | Same pattern; regenerate 7-char id via naming |

Secret **names** (e.g. `SRVAPPHADJ`) stay; vault resource name changes → update PS that resolve vault by name.

---

## Script / pipeline touch list (name strings only)

When applying this map, search-replace carefully in:

1. `legacy/mult/vdi-mult/params/hostpools/*.json` + deploy scripts  
2. `legacy/scripts/vdi-scripts/params/**` + placement modules  
3. `legacy/images/vdi-images/packer/*.pkr.hcl` + gallery params  
4. Alert templates that embed host pool / scaling plan names  
5. AzDo variable groups / `config.yml` gallery + RG name keys  

Prefer consuming **Terraform outputs** after cutover instead of duplicating name strings.

---

## Out of rename scope

- Session host computer names (`MSH*`, PERS hostnames)  
- On-prem AD objects  
- SPN / service connection names (`SC-*-VDI-*-C-01`) — unchanged until GLB decoupling  
- Private agent names (`uks-{env}-vdi-mgmt-vss-01`) — unchanged while agents stay PS  
