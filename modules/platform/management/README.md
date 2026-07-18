# modules/platform/management

Deploys the shared **observability platform** for a region/environment. All other
platform, core, and AVD modules send diagnostics to the workspace created here
(via their `log_analytics_workspace_id` input, wired from `law_id`).

## Azure resources

- `azurerm_log_analytics_workspace` (always)
- `azurerm_monitor_data_collection_endpoint` (when `create_data_collection_endpoint`)
- `azurerm_monitor_data_collection_rule` — AVD Insights perf counters + Windows
  events (when `create_avd_insights_dcr`)
- `azurerm_monitor_action_group` (per `action_groups`)
- `azurerm_monitor_metric_alert` (per `metric_alerts`)
- `azurerm_monitor_activity_log_alert` (per `activity_log_alerts`)
- `azurerm_monitor_scheduled_query_rules_alert_v2` (per `scheduled_query_alerts`)
- `azurerm_application_insights_workbook` (per `workbooks`)

## Alert -> action group wiring

Alerts reference action groups by their **key** in `var.action_groups`
(`action_group_keys`). The module resolves keys to the generated action group
resource IDs — callers never handle IDs.

## Key outputs

- `law_id` — consumed by every module's diagnostic settings
- `law_workspace_id`, `law_name`
- `data_collection_endpoint_id`, `avd_insights_dcr_id`
- `action_group_ids`

> Abbreviations `dce`, `sqr`, `wkb` are PENDING TDA sign-off (LLD Open Item 2).

See [`examples/basic`](examples/basic) for usage.
