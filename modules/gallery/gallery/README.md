# modules/gallery/gallery

Deploys **one Azure Compute Gallery per region**, plus RBAC role assignments (the
Packer build MSI needs Contributor to publish image versions).

## Scope boundary

Terraform manages the **gallery** and (via `modules/gallery/image-definition`)
the image **definitions** only. Image **versions** — PERS (stripped-down + Proxy
baked in) and MSH (base image + per-BU app artefacts) — are built and published
by the **Packer pipelines**, not Terraform.

## Azure resources

- `azurerm_shared_image_gallery`
- `azurerm_role_assignment` (per `role_assignments`)

## Naming

Azure Compute Gallery names disallow hyphens, so the naming module emits an
**underscore-joined** name for `compute_gallery` (e.g. `uks_vdi_gal_avd_01`).

## Outputs

`gallery_id` (consumed by image-definition + Packer), `gallery_name`.

See [`examples/basic`](examples/basic) for usage.
