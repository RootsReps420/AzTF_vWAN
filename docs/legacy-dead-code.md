# Legacy dead / out-of-scope code (Phase 0)

Artifacts **not** ported in the Azure 1.0 → Terraform migration.

---

## Retired trees

| Path | Reason |
|---|---|
| `scripts/vdi-scripts/pipelines/retired/` (21 YAML) | Superseded by live ops |
| `scripts/vdi-scripts/arm/retired/` | Old templates |
| `scripts/vdi-scripts/params/retired/` | Old Lookup / PERS packs |
| `scripts/vdi-scripts/modules/retired/` | Orphaned PSM1 |
| `mult/vdi-mult/pipelines/retired/` (~35 YAML) | Superseded by AB / targeted pipelines |

**Scripts retired pipelines (do not revive):**  
`New-MMDRoleAssign`, `New-VDIMigration`, `New-VDIPowerAction`, `New-VDIPowerScheduleQuery`, `New-VDIRightSize`, `Reset-PreProv`, `Update-ADEKeyVersion`, `Update-VMTrustedLaunch`, `vdi_CloudObjectTag`, `vdi_CloudResourceTag`, `vdi_DeployMonitorWorkbook`, `vdi_NewKey`, `vdi_vmBootDiag`, `vdi_vmBootDiagnostics`, `vdi_vmConsistencyCheck`, `vdi_vmDeallocateStopped`, `vdi_vmDecom`, `vdi_vmDecomManual`, `vdi_vmEditShutdown`, `vdi_vmNewVM`, `vdi_vmResize`.

---

## PPD (pre-prod) — drop entirely

| Path | Reason |
|---|---|
| `mult/.../pipelines/schedules/ppd/` | PPD schedules — RETIRE |
| `*/params/ppd/**` | Env retired; map `prd`→`prod` only |
| `scripts/.../params/*_PPD.json`, `DecomExclusions_PPD.csv` | PPD packs |
| `images/.../params/gallery/ppd/` | PPD gallery env |

---

## Peering-as-peering (topology retire)

| Path | Reason |
|---|---|
| `platform/.../bicep/peering/` | Replaced by vWAN hub connections |
| `platform/.../pipelines/peering/{build,release}_pipeline.yml` | Fate RETIRE |
| `platform/.../params/{env}/01/peering/` | Informational only — do not recreate peerings |

---

## Debug Bicep

| Path | Reason |
|---|---|
| `scripts/.../arm/uks-EEE-vdi-avd-dcr-pers-debug.bicep` | Debug — not live |
| `scripts/.../arm/uks-EEE-vdi-avd-dcr-pers-debug2.bicep` | Debug — not live |

---

## Gallery / Packer mismatches

From `images/.../params/gallery/configSets.json`:

| Item | Reason |
|---|---|
| `gallerySets.galleryTestExample` | Test set — not production |
| ~14 `galleryStandard` defs with no matching `packer/*.pkr.hcl` | Confirm live need before TF port; do not invent Packer |
| Orphan Packer without galleryStandard def | Confirm before wiring |

---

## Mirrors

| Path | Reason |
|---|---|
| `legacy/platformtest/**` | Excluded; **not present** in this checkout |
| `legacy/scriptstest/**` | Excluded; **not present** |

If re-cloned: treat as OUT of scope (duplicates).

---

## Deferred (not dead — out of TF cutover)

| Path | Reason |
|---|---|
| `initiatives/vdi-initiatives/**` | Azure Policy workstream |
| All `*/sub_pipeline.yml` | Subscription create — GLB/PS |
| `platform/.../mgmt/nightly_pipeline.yml` | GLB sub destroy |
| `libraries/.../azure-pipelines-vdi-monitoring-policy-law-update.yml` | Policy LAW |
| Full `params-netsec.json` / PAC | → Azure Policy; TF baseline FWP only |
| Hub02 VPN site/connection + final MSH UDR | Other engineer |

---

## Pipeline fragments (not entry points)

`**/pipelines/{jobs,stages,steps,templates,resources}/**` — support templates only.

---

## Checkout status

| Repo | Status |
|---|---|
| platform, scripts, images, mult, pers, initiatives, libraries | Present |
| pers/vdi-core-pers | **Complete** (bicep + params + pipelines) |
| platformtest, scriptstest | Absent |

---

## NSG flow logs

Params may reference flow logs; **no** `flowLogs` resource in live Bicep. Deferred until SecOps confirms.
