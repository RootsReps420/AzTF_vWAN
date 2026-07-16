# modules/avd/hostpool

Deploys an **AVD Host Pool** and issues the session-host **registration token**
consumed by the `vdi-mult` session-host deployment pipelines.

## What it deploys

| Resource | Azure type |
|----------|-----------|
| Host Pool | `Microsoft.DesktopVirtualization/hostPools` |
| Registration Info (token) | `Microsoft.DesktopVirtualization/hostPools/registrationInfo` (via `azurerm_virtual_desktop_host_pool_registration_info`) |

## Registration token & rotation

The registration token is time-bound. Rather than compute an expiry from
`timestamp()` (which produces a perpetual plan diff), the module drives the
`expiration_date` from a `time_rotating` resource. The token is therefore
**re-issued automatically** every `token_validity_hours`, so pipelines always
have a valid token to join session hosts — no manual rotation required.

The token is exposed as a **sensitive** output; never log or echo it.

## Personal vs Pooled

`maximum_sessions_allowed` applies only to **Pooled** pools and
`personal_desktop_assignment_type` only to **Personal** pools. The module nulls
out whichever does not match `host_pool_type`, so you can leave the irrelevant
one at its default. Use `Persistent` load balancing for Personal pools and
`BreadthFirst`/`DepthFirst` for Pooled pools.

## Usage

```hcl
module "vdi_mult_hostpool" {
  source = "../../modules/avd/hostpool"

  name                = "vdi-mult-uks"
  resource_group_name = "rg-avd-prod"
  location            = "uksouth"

  host_pool_type           = "Pooled"
  load_balancer_type       = "BreadthFirst"
  maximum_sessions_allowed = 12

  custom_rdp_properties = "audiocapturemode:i:1;drivestoredirect:s:;redirectclipboard:i:0"
  token_validity_hours  = 24

  tags = {
    environment = "prod"
    workload    = "vdi-mult"
  }
}
```

Passing the token to a session-host pipeline (keep it sensitive):

```hcl
output "avd_registration_token" {
  value     = module.vdi_mult_hostpool.registration_token
  sensitive = true
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `name` | Base name for the host pool | `string` | — |
| `resource_group_name` | Target resource group | `string` | — |
| `location` | Azure region | `string` | — |
| `host_pool_type` | `Personal` \| `Pooled` | `string` | — |
| `load_balancer_type` | `BreadthFirst` \| `DepthFirst` \| `Persistent` | `string` | `BreadthFirst` |
| `maximum_sessions_allowed` | Max concurrent sessions per host (Pooled only, 1-999999) | `number` | `16` |
| `personal_desktop_assignment_type` | `Automatic` \| `Direct` (Personal only) | `string` | `Automatic` |
| `preferred_app_group_type` | `Desktop` \| `RailApplications` \| `None` | `string` | `Desktop` |
| `custom_rdp_properties` | Semicolon-delimited RDP properties | `string` | `null` |
| `token_validity_hours` | Registration token validity / rotation cadence, in hours (1-720) | `number` | `24` |
| `friendly_name` | Display name in the AVD client | `string` | `null` |
| `description` | Host pool description | `string` | `null` |
| `validate_environment` | Opt into the validation environment | `bool` | `false` |
| `start_vm_on_connect` | Allow Start VM on Connect | `bool` | `false` |
| `tags` | Tags applied to the host pool | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `hostpool_id` | Host pool resource ID |
| `hostpool_name` | Host pool name |
| `registration_token` | **Sensitive** — session-host registration token (used by `vdi-mult` pipelines) |
| `registration_token_expiration` | RFC3339 expiry of the current token |
