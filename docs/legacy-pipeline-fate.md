# Legacy pipeline fate (Phase 0)

Entry points only (not `jobs/` / `stages/` / `steps/` / `templates/` / `resources/` fragments).  
Repos: `legacy/{platform,scripts,images,mult,pers,initiatives,libraries}`.  
Excluded: `pipelines/retired/**`, `platformtest` / `scriptstest` (not in this checkout).

Fate values: **Terraform** | **stays-PS** | **Packer** | **RETIRE** | **DEFER**

---

## platform / vdi-platform

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/hub/build_pipeline.yml` | Bicep build validate hub | Terraform | C / H |
| `pipelines/hub/release_pipeline.yml` | Bicep release hub VNet/FW/ER | Terraform | C / H → vWAN hubs + baseline FWP |
| `pipelines/hub/delete_pipeline.yml` | Bicep delete hub | Terraform | H — TF destroy |
| `pipelines/hub/sub_pipeline.yml` | Create hub subscription (GLB) | DEFER | Sub create stays GLB/PS |
| `pipelines/mgmt/build_pipeline.yml` | Bicep build mgmt spoke | Terraform | D / H — agent VMSS stays PS |
| `pipelines/mgmt/release_pipeline.yml` | Bicep release mgmt | Terraform | D / H |
| `pipelines/mgmt/delete_pipeline.yml` | Bicep delete mgmt | Terraform | H |
| `pipelines/mgmt/sub_pipeline.yml` | Create mgmt subscription (GLB) | DEFER | |
| `pipelines/mgmt/nightly_pipeline.yml` | Nightly sub destroy (GLB) | DEFER | GLB sub lifecycle |
| `pipelines/law/build_pipeline.yml` | Bicep build LAW | Terraform | D / H |
| `pipelines/law/release_pipeline.yml` | Bicep release LAW | Terraform | D / H |
| `pipelines/avd/build_pipeline.yml` | Bicep build AVD-sub KV/RGs | Terraform | D / H |
| `pipelines/avd/release_pipeline.yml` | Bicep release AVD-sub | Terraform | D / H |
| `pipelines/avd/delete_pipeline.yml` | Bicep delete AVD-sub | Terraform | H |
| `pipelines/avd/sub_pipeline.yml` | Create AVD subscription (GLB) | DEFER | |
| `pipelines/alerts/release_pipeline.yml` | Deploy AVD alerts + APR | Terraform | D / H |
| `pipelines/peering/build_pipeline.yml` | Bicep build VNet peering | RETIRE | → `virtual_hub_connection` |
| `pipelines/peering/release_pipeline.yml` | Bicep release peerings | RETIRE | → hub connections |
| `pipelines/keyvault/New-VDIKeyVaultLifecycle.yml` | Create/recover KV + PE | stays-PS | Vault shell TF; lifecycle PS |
| `pipelines/keyvault/Update-VDIKeyVaultLifecycle.yml` | Update KV lifecycle | stays-PS | D |
| `pipelines/keyvault/Remove-VDIKeyVaultLifecycle.yml` | Remove KV lifecycle | stays-PS | D |

---

## scripts / vdi-scripts

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/New-VDIAVDHostpool.yml` | Deploy PERS HP + AG + workspace | Terraform | E / H |
| `pipelines/New-VDIAVDPersonalScalingPlan.yml` | Deploy personal scaling plan | Terraform | E |
| `pipelines/New-VDIDataCollectionRule.yml` | Deploy DCRs + tables | Terraform | D |
| `pipelines/New-VDIBuildPERS_Single.yml` | Build single PERS session host | stays-PS | |
| `pipelines/New-VDIBuildPERS_Single_Packaging.yml` | Build packaging PERS host | stays-PS | |
| `pipelines/New-VDIBuildPERS_PreProv.yml` | Pre-provision PERS hosts | stays-PS | |
| `pipelines/New-JSONDeploy.yml` | JSON-driven multi object deploy | stays-PS | |
| `pipelines/New-VDIConfig.yml` | Create VDI config objects | stays-PS | |
| `pipelines/Update-VDIConfig.yml` | Update VDI config | stays-PS | |
| `pipelines/New-VDIDecom.yml` | Decommission PERS VMs | stays-PS | |
| `pipelines/New-VDIDecom_Packaging.yml` | Decom packaging hosts | stays-PS | |
| `pipelines/New-VDIDecomSchedule.yml` | Scheduled PERS decom | stays-PS | |
| `pipelines/New-VDIDecomSchedule_Packaging.yml` | Scheduled packaging decom | stays-PS | |
| `pipelines/Remove-AVDHostpool.yml` | Delete AVD HP objects | stays-PS | |
| `pipelines/Start-TokenRenewal.yml` | Renew AVD registration tokens | stays-PS | |
| `pipelines/Start-VDIPowerMgmtSchedule.yml` | Power mgmt schedule | stays-PS | |
| `pipelines/Start-VDIPowerMgmtSchedule_Packaging.yml` | Packaging power schedule | stays-PS | |
| `pipelines/New-VDIPowerActionTrigger.yml` | Ad-hoc power action | stays-PS | |
| `pipelines/New-VDIPowerActionTrigger_Packaging.yml` | Packaging power action | stays-PS | |
| `pipelines/Start-AVDSnapshots.yml` | AVD VM snapshots | stays-PS | |
| `pipelines/Start-AVDDiskExpand.yml` | Expand disks | stays-PS | |
| `pipelines/Start-VMRedeploy.yml` | Redeploy VM | stays-PS | |
| `pipelines/Update-VMDiskAccess.yml` | Disk network access | stays-PS | |
| `pipelines/Update-VMDiskTypeTrigger.yml` | Disk type change | stays-PS | |
| `pipelines/Update-VMSizeTrigger.yml` | VM size change | stays-PS | |
| `pipelines/Update-BootDiagStatus.yml` | Boot diagnostics | stays-PS | |
| `pipelines/Update-VMInsights.yml` | VM Insights | stays-PS | |
| `pipelines/Set-ADEKeyRotation.yml` | ADE key rotation | stays-PS | |
| `pipelines/Update-RoleAssignment.yml` | Role assignment update | stays-PS | |
| `pipelines/Update-VDIRoleAssign.yml` | VDI RBAC assign | stays-PS | |
| `pipelines/Update-VDIRoleAssign_Packaging.yml` | Packaging RBAC | stays-PS | |
| `pipelines/Update-SHAssignment.yml` | Session host user assign | stays-PS | |
| `pipelines/Update-HostpoolAADMembership.yml` | HP AAD group membership | stays-PS | |
| `pipelines/Move-VDIHostPool.yml` | Move SH between HPs | stays-PS | |
| `pipelines/Get-AVDCostSavingsReport.yml` | Cost savings report | stays-PS | |
| `pipelines/Get-AVDPERSPackagingInfo.yml` | Packaging info report | stays-PS | |
| `pipelines/retired/*.yml` (21) | Retired ops | RETIRE | See dead-code doc |

---

## images / vdi-images

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/vdi_gallery_deployment.yml` | Deploy gallery + defs | Terraform | F / H |
| `pipelines/vdi_build_pers_images_manual.yml` | Packer PERS versions | Packer | F |
| `pipelines/vdi_build_mult_images_manual.yml` | Packer MSH versions | Packer | F |
| `pipelines/vdi_build_mult_images_scheduledAB.yml` | Packer MSH scheduled | Packer | F |
| `pipelines/vdi_build_packaging_images_scheduled.yml` | Packer packaging | Packer | F |
| `pipelines/vdi_build_azdoagent_images_manual.yml` | Packer AzDo agent | Packer | F |
| `pipelines/vdi_build_azdoagent_images_scheduled.yml` | Packer AzDo agent sched | Packer | F |
| `pipelines/vdi_build_azdoagent_image_testing.yml` | Packer agent test | Packer | F |
| `pipelines/vdi_purge_versions_*` | Purge gallery versions | stays-PS | Note PERS purge has double `.yml.yml` |
| `pipelines/vdi_reconcile_versions*.yml` | Reconcile versions | stays-PS | |
| `pipelines/vdi_delete_version.yml` | Delete image version | stays-PS | |
| `pipelines/vdi_delete_definition.yml` | Delete image definition | stays-PS | Prefer TF after cutover |
| `pipelines/vdi_copy_image_version.yml` | Copy image version | stays-PS | |
| `pipelines/vdi_change_version_tags.yml` | Change version tags | stays-PS | |
| `pipelines/vdi_change_version_excludefromlatest.yml` | Toggle excludeFromLatest | stays-PS | |
| `pipelines/vdi_code_release.yml` | Repo code/tag release | stays-PS | |
| `pipelines/vdi_mult_pr_branch_check.yml` | PR branch check | stays-PS | |

---

## mult / vdi-mult

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/vdi_mult_avd_release.yml` | Deploy MSH HP/SP/workspace/DCR | Terraform | E / H — per-BU scaling |
| `pipelines/vdi_fslogix_deployment.yml` | FSLogix storage/shares | Terraform | D / H |
| `pipelines/vdi_mult_sessionhost_*.yml` | Host release/rotation/decom/DR/maint | stays-PS | |
| `pipelines/vdi_mult_user_*.yml` / `vdi_mult_remove_role_assignment.yml` | Assignments | stays-PS | |
| `pipelines/vdi_fslogix_profile_*.yml` / `vdi_fslogix_RedirectionXML.yml` | Profile ops | stays-PS | |
| `pipelines/vdi_mult_manage_share_handles.yml` / `vdi_mult_remove_profile_handles.yml` | Share handles | stays-PS | |
| `pipelines/vdi_mult_dns_monitoring.yml` | DNS monitoring | stays-PS | |
| `pipelines/vdi_mult_windows_service_restart.yml` | Service restart | stays-PS | |
| `pipelines/vdi_com_*.yml` | Locks / runscript | stays-PS | |
| `pipelines/vdi_mult_code_release.yml` / `vdi_mult_pr_branch_check.yml` / `pester_tests.yml` | CI | stays-PS | |
| `pipelines/schedules/int/**` / `schedules/prd/**` | INT/PRD schedules | stays-PS | |
| `pipelines/schedules/ppd/**` | PPD schedules | RETIRE | Drop ppd |
| `pipelines/retired/**` | Retired MSH pipelines | RETIRE | |

---

## pers / vdi-core-pers

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/labCorePersistent/build_pipeline.yml` | Bicep build lab spoke | Terraform | C / H |
| `pipelines/labCorePersistent/release_pipeline.yml` | Bicep release lab spoke | Terraform | C |
| `pipelines/labCorePersistent/delete_pipeline.yml` | Bicep delete lab spoke | Terraform | H |
| `pipelines/labCorePersistent/sub_pipeline.yml` | Create lab subscription | DEFER | GLB/PS |

Checkout verified complete (bicep + params + pipelines).

---

## initiatives / vdi-initiatives

All 7 pipelines (`initiatives/*`, `assignments/*`) → **DEFER** (Azure Policy / Secure-Hub AZFW→Policy workstream).

---

## libraries / vdi-libraries

| Pipeline path | Purpose | Fate | Plan phase / notes |
|---|---|---|---|
| `pipelines/azure-pipelines-avd-law-update.yml` | AVD diagnostics → LAW | Terraform | D — fold into management |
| `pipelines/azure-pipelines-vdi-monitoring-policy-law-update.yml` | Monitoring policy LAW | DEFER | Policy workstream |
| `pipelines/device_localadmin_*.yml` | Device local-admin | stays-PS | |
| `pipelines/vdi_group_membership.yml` | AAD group membership | stays-PS | |
| `pipelines/vdi_move_vm_host_pool.yml` | Move VM between HPs | stays-PS | |
| `pipelines/vdi_remove_session*.yml` | Remove sessions | stays-PS | |
| `pipelines/vdi_code_release.yml` / `vdi_pr_branch_check.yml` / `pester_tests.yml` | CI | stays-PS | |
| `pipelines/schedules/vdi_schedule_tag_cleanup.yml` | Tag cleanup | stays-PS | |

---

## Fate summary (entry points)

| Fate | Approx | Primary owners |
|---|---|---|
| Terraform | ~25 | platform hub/mgmt/law/avd/alerts; scripts HP/SP/DCR; gallery; mult AVD+FSLogix; pers lab; libraries LAW |
| stays-PS | ~90+ | scripts/mult/images ops; KV lifecycle; libraries helpers; schedules int/prd |
| Packer | 7 | images `build_*` |
| RETIRE | peering×2 + mult ppd×3 + all `*/retired/**` | |
| DEFER | sub_* + nightly + initiatives + monitoring-policy LAW | |
