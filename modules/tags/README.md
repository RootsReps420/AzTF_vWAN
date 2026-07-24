# modules/tags

Enforces the **bank tagging standard**. A pure-computation module (no Azure
resources) that merges mandatory, platform, and additional tags into a single
map. **Every other module** passes this output straight to its resources'
`tags` argument.

## Behaviour

- **Mandatory tags** are a typed `object`, so `terraform plan` **fails** if any
  required key is missing. A validation rule additionally rejects empty values.
- **Platform tags** are auto-applied to every resource:
  `managed-by = "terraform"`, `environment`, `region`, `workload`,
  `repo = "vdi-terraform"`.
- **Additional tags** extend the set per workload but merge at **lowest
  precedence** — they can add keys but never override the standard.

Precedence (low → high): `additional` → `mandatory` → `platform`.

## Usage

```hcl
module "tags" {
  source = "../../tags"

  workload    = "vdi-mult"
  environment = "prod"
  region      = "uksouth"

  mandatory = {
    costCentre             = "CC-4821"
    securityClassification = "Internal"
    resourceOwner          = "avd-platform@example.com"
    CMDB_AppID             = "APP-12345"
  }

  additional = {
    "cost-optimisation" = "auto-shutdown"
  }
}

# Pass straight through to resources:
#   tags = module.tags.tags
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `mandatory` | Required bank tags (typed object — missing key fails plan) | `object` | — |
| `workload` | `workload` tag value | `string` | — |
| `environment` | `environment` tag value | `string` | — |
| `region` | `region` tag value | `string` | — |
| `additional` | Optional workload-specific tags (lowest precedence) | `map(string)` | `{}` |

### `mandatory` object

| Key | Description |
|-----|-------------|
| `costCentre` | Charge-back cost centre code |
| `securityClassification` | e.g. Public / Internal / Confidential |
| `resourceOwner` | Accountable owner (team or DL) |
| `CMDB_AppID` | CMDB application identifier |

## Outputs

| Name | Description |
|------|-------------|
| `tags` | Merged tag map — pass to the `tags` argument on resources |
