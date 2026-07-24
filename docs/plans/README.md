# Migration & Build Plans

Versioned record of the major planning efforts for the VDI Terraform platform.
Each plan is captured as a standalone markdown doc so the history and rationale
live in the repo (the live working copies are authored in Cursor's plan mode).

## Index

| # | Plan | Status | Summary |
|---|------|--------|---------|
| 01 | [VDI Terraform Platform Buildout](01-vdi-terraform-buildout.md) | Complete | Greenfield build of the full module catalogue (naming, tags, platform, core, avd, gallery) + `_global` and `uksouth/{dev,prod}` environment roots. |
| 02 | [Azure 1.0 to Terraform Migration](02-azure-1.0-to-terraform-migration.md) | Planned | Port the legacy Azure 1.0 estate (vdi-platform, vdi-scripts, vdi-images) onto the Terraform modules; re-platform hub-peering to vWAN; TDA naming; multi-subscription topology preserved. |

## Conventions

- Plans are numbered in the order they were created.
- Status: `Planned` -> `In progress` -> `Complete`.
- Diagrams use Mermaid so they render in GitHub / Cursor.
- When a plan is superseded, keep the file and note the successor at the top.
