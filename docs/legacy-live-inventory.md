# Legacy live inventory (Phase 0)

In-scope artifacts reachable from non-retired pipelines, grouped by migration plan phase.  
Paths relative to `legacy/`.

---

## Phase C — Connectivity + firewall + spokes

### Bicep
| Path | Role |
|---|---|
| `platform/vdi-platform/bicep/hub/` | Hub VNet, FW, ER → vWAN Hub01/Hub02 |
| `platform/vdi-platform/bicep/hub/rsg_*rulecollections.bicep` | Full rules **deferred**; baseline FWP only |
| `platform/vdi-platform/bicep/peering/` | **RETIRE topology** → `virtual_hub_connection` |
| `pers/vdi-core-pers/bicep/labCorePersistent/` | PERS lab spoke → `spoke-pers` |
| `pers/vdi-core-pers/bicep/labCoreMulti/` | MSH lab spoke → `spoke-msh` + storage |
| `pers/vdi-core-pers/bicep/labCorePriv/` | Privileged lab spoke |
| `pers/vdi-core-pers/scripts/sub_subsInfo.ps1` | Sub discovery → explicit TF connections |

### Params — net keys (verbatim → tfvars)
Envs: `idv`, `ici`, `itt`, `int`, `ppd`(**drop**), `prd`→`prod`.

Sources: `platform/.../params/{env}/config.yml`, `pers/.../params/{env}/config.yml`.

Key patterns: `net_superNetCidr`, `net_hub_01_*`, `net_mgmt_*`, `net_lab_core_pers_*`, `net_lab_core_mult_*`, `net_lab_core_priv_*`.

Corporate DNS: `platform/.../params/{env}/01/hub/params.json` → `p_dnsServers: "10.19.96.1,10.19.97.1"`.

Also: `params/{env}/01/hub/params.json`, `params-netsec.json` (full FW deferred), `params/{env}/01/peering/` (informational only).

---

## Phase D — Platform services

| Path | Role |
|---|---|
| `platform/.../bicep/law/` | Log Analytics |
| `platform/.../bicep/mgmt/` | Mgmt VNet, access RBAC, Network Watcher |
| `platform/.../bicep/mgmt/agents.bicep` | Agent VMSS — **stays PS** |
| `platform/.../bicep/avd/rsg_keyvault.bicep` | AVD-sub KV → `core/keyvault` |
| `platform/.../bicep/alerts/` | APR, UAMI, ~17 `alert-templates/` |
| `scripts/.../arm/uks-EEE-vdi-avd-dcr-*.bicep` + `Tables.bicep` | PERS/PRIV DCRs + tables |
| `mult/.../bicep/avd/vdi_dcr.bicep` + `vdi_customtables.bicep` | MSH DCR/tables |
| `mult/.../bicep/fslogix/` | FSLogix storage → `storage-fslogix` |
| `libraries/.../scripts/Update-AvdLawReferences.ps1` | Fold into TF LAW |

Params: `params/{env}/01/{law,mgmt,avd,alerts}/`, `mult/.../params/{int,prd}/environment.json`.

---

## Phase E — AVD objects + per-BU MSH scaling

| Path | Role |
|---|---|
| `scripts/.../arm/VDI-New-Hostpool-Appgroup-Workspace.bicep` | PERS HP/AG/WS |
| `scripts/.../arm/AVD-ScalingPlan.bicep` | Personal scaling |
| `mult/.../bicep/avd/` | MSH HP/SP/workspace release |
| `mult/.../params/scalingPlanSchedules.json` | Shared schedule catalog |
| `mult/.../params/scalingPlanSchedulesDecom.json` | Decom catalog |
| `mult/.../params/hostpools/uks-EEE-vdi-avd-hpl-mult-{BU}-{pool}.json` | **30** pools — select schedule keys |
| `scripts/.../params/AVD-ScalingPlans.json` | PERS personal schedule template |

### MSH scaling variance (port exactly)
| Pattern | Schedule keys | Applies to |
|---|---|---|
| Standard | `standard_weekdays_schedule` + weekend | Most `{BU}-01` / `-02` |
| Canary (`-00`) | `*_canary` + weekend | Pool `00` (non-005) |
| BU **005** | `*_005` / `*_005_canary` + weekend | Consumer Relationships |
| Decom sibling | from decom catalog | Per-pool `-decom` SP |

BUs: `001`–`009`, `999` × pools `00`/`01`/`02`.

---

## Phase F — Gallery

| Path | Role |
|---|---|
| `images/.../bicep/gallery/` | Gallery + roles |
| `images/.../params/gallery/configSets.json` | ~50 defs |
| `images/.../params/gallery/{idv,int,prd}/environment.json` | Per-env RBAC |
| `images/.../packer/*.pkr.hcl` | **37** Packer templates (versions stay Packer) |

---

## Phase H — AzDo TF stages

Replace GLB Bicep deploy stage for: platform hub/mgmt/law/avd/alerts, pers lab, gallery, mult AVD + FSLogix storage. Keep SPNs/agents; do not rewrite GLB.

---

## stays-PS (do not port)

- PERS/MSH/Packaging **session host** build (`VDI-Pers.bicep`, mult `sessionhosts/`)
- Placement, token renew/consume, decom, power, disk/TL/ADE, snapshots
- VM/AAD RBAC, assignments, move HP, session remove
- FSLogix profile delete/housekeep/handles/redirection XML
- Packer versions + gallery purge/reconcile/tag/copy/delete
- Sub create/destroy (GLB), agent VMSS, KV lifecycle scripts, libraries helpers
- PAC (interim only while FW policy holds rules)
