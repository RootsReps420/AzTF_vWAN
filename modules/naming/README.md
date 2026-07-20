# modules/naming

Implements the **TDA ARN Naming Standard v2**. A pure-computation module (no
Azure resources) that turns a resource type + context into a bank-compliant
resource name. **Every other module calls this** — names are never hardcoded.

## Behaviour

- Resolves the bank **abbreviation** for the given `resource_type`.
- Resolves the **region short code** for the given `location`.
- Selects the correct **naming pattern** for the resource family. Segment order
  follows the TDA standard — **region first**:

| Family | Pattern | Example |
|--------|---------|---------|
| Default (TDA §9.2) | `{region}-{subscription}-{abbr}-{description\|id}` | `uks-conn-afw-hub01` |
| Resource Group (TDA §9.1) | default pattern, abbr `rsg` | `uks-conn-rsg-global` |
| Storage Account (`storage_account`, `fslogix_storage_account`, `blob_storage_account`) | `{region}{env}{service}{subscription}{id}` — no resource abbr; lowercased, alphanumeric only, ≤ 24 chars (TDA §9.3) | `uksdevpersvdi01` |
| Key Vault (`key_vault`) | `{region}-{env}-{service}-kvt-{7charId}` — lowercased, ≤ 24 chars (TDA §11.1) | `uks-dev-pers-kvt-prslb01` |
| Managed Identity (`managed_identity`, `managed_user_id`) | `{service}-{env}-msi-{resource}-{description}-{id}` (service = subscription segment; TDA §13.5) | `psv-pd1-msi-iam-workbook-01` |
| Compute Gallery (`compute_gallery`) | underscore-joined (Azure disallows hyphens) | `uks_conn_gal_avd` |

- **Fails `terraform plan`** with a clear, enumerated error if an unknown
  `resource_type` or `location` is passed (via `terraform_data` preconditions).

Empty segments (e.g. an omitted `unique_id`) are dropped, so no double hyphens.

## Marker legend

- `PENDING(TDA)` — abbreviation/region not yet defined or approved in the TDA
  standard; provisional and may change on sign-off.
- `PENDING(LLD)` — open design item tracked in the solution LLD.

## Pending TDA sign-off

The following are included but **awaiting TDA approval** (LLD Open Items 1 & 2)
and may change. The TDA standard defines only `uks`/`ukw` and has **no** AVD
abbreviations:

- Region codes (non-standard): `italynorth` → `itn`, `spaincentral` → `spc`,
  `northeurope` → `neu`, `westeurope` → `weu`. Only `uks`/`ukw` are TDA-approved.
- AVD abbreviations (provisional, 3-letter to satisfy the §9.2 `[a-z]{3}` rule):
  `avd_host_pool` → `vdh`, `avd_workspace` → `vdw`, `avd_application_group` →
  `vda`, `avd_scaling_plan` → `vds`.
- Monitoring abbreviations: `dce`, `sqr`, `wkb` (no TDA code defined).
- `ip_group` → `ipg` (no TDA abbreviation defined — local convention).

## Abbreviations

See the `abbreviations` map in [`main.tf`](main.tf) for the full, authoritative
list (networking, storage, identity, observability, compute, AVD, structure).
Corrected against TDA §5: `maa` = Monitor Activity Alert, `mma` = Monitor Metric
Alert, `mdc` = Monitor Data Collection Rule.

### Regions

`uksouth`→`uks`, `ukwest`→`ukw`, `italynorth`→`itn`, `spaincentral`→`spc`,
`northeurope`→`neu`, `westeurope`→`weu`.

## Usage

```hcl
module "firewall_name" {
  source = "../../naming"

  resource_type   = "azure_firewall"
  location        = "uksouth"
  subscription_id = "conn"
  description     = "hub01"
  unique_id       = "01"
}

# module.firewall_name.name         => "uks-conn-afw-hub01-01"
# module.firewall_name.abbreviation => "afw"
# module.firewall_name.region_short => "uks"
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `resource_type` | Resource-type slug to name | `string` | — |
| `location` | Azure region (first name segment) | `string` | — |
| `subscription_id` | Subscription segment (service short name for MSI) | `string` | `""` |
| `environment` | Environment segment (KV/Storage/MSI patterns) | `string` | `""` |
| `description` | Short workload/purpose descriptor | `string` | `""` |
| `unique_id` | Optional instance suffix | `string` | `""` |
| `resource_code` | 3-letter resource code for the Managed Identity `{resource}` segment (TDA §13.5) | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| `name` | Bank-compliant resource name |
| `abbreviation` | Resolved bank abbreviation |
| `region_short` | Resolved region short code |
