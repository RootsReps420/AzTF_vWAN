# modules/avd/scalingplan

Deploys an **AVD Scaling Plan**, associates it with host pools, and defines its
schedules for power management.

## Azure resources

- `azurerm_virtual_desktop_scaling_plan` (+ `host_pool` associations + pooled `schedule` blocks)
- `azapi_resource` — `Microsoft.DesktopVirtualization/scalingPlans/personalSchedules`
  (per `personal_schedules`)

## Why azapi for personal schedules

The azurerm provider (<= 4.x) has **no native resource** for personal-desktop
scaling schedules. Since the PERS estate is personal-desktop, personal schedules
are implemented via `azapi`. The `properties` object in each `personal_schedules`
entry is passed straight through to the ARM body — see the example for the shape.

Pooled schedules continue to use the native azurerm `schedule` block.

## Providers

Requires **azapi `>= 2.0`** in addition to azurerm. Root configs/examples using
personal schedules must declare and configure the `azapi` provider.

## Depends on

- `host_pool_associations[*].hostpool_id` — output `hostpool_id` from
  `modules/avd/hostpool`

## Outputs

`scaling_plan_id`, `scaling_plan_name`, `personal_schedule_ids`.

> Abbreviation `vdsp` is PENDING TDA sign-off (LLD Open Item 2).

See [`examples/basic`](examples/basic) for usage.
