# Packer / pipeline TDA rename checklist (Phase F leftover)

Terraform gallery + image definitions emit **TDA names** via `modules/naming`.
Packer `.pkr.hcl` and AzDo image pipelines still reference **legacy** gallery /
definition names until updated.

Use:

1. `docs/legacy-to-tda-rename-map.md` — patterns
2. `terraform output image_definition_names` from `environments/<env>/avd` — concrete map (`TF key → legacy_name`)
3. `terraform output gallery_name` — new gallery name

## Update targets (stay in images repo / pipelines — not this TF apply)

| Artifact | Action |
|---|---|
| `legacy/images/.../packer/*.pkr.hcl` (~37) | Point `gallery_name` / `managed_image_name` / shared image name at TDA outputs |
| `Images_CreateInputVariablesJSON.ps1` | Emit TDA definition names |
| Gallery deploy Bicep path | **RETIRE** after TF cutover (`vdi_gallery_deployment.yml`) |
| Version purge / reconcile / tag pipelines | Update name filters only; keep Packer version builds |

Do **not** rewrite Packer build logic here — only name references.
