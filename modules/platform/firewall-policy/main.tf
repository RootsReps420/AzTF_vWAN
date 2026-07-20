# ---------------------------------------------------------------------------
# Platform — Firewall Policy
#
# Deploys the Azure Firewall Policy and its rule collection groups, plus any
# IP Groups referenced by the rules. Firewall rules are defined HERE, not inline
# on the firewall resource in modules/platform/hub-secured — the policy is the
# single source of truth and is attached to the hub firewall via policy_id.
#
# Rule collection naming follows TDA §10:
#   collections : {allow|deny}-{environment}-{service}-{description}
#   rules       : {inbound|outbound}-{description}
# Names are supplied by the caller as the map keys in var.rule_collection_groups.
#
# IP Groups are created here and referenced from rules by their map key
# (source_ip_group_keys / destination_ip_group_keys) — callers never need the
# generated resource IDs.
# ---------------------------------------------------------------------------

module "policy_name" {
  source = "../../naming"

  resource_type   = "firewall_policy"
  location        = var.location
  subscription_id = var.subscription_id
  environment     = var.environment
  description     = var.name
  unique_id       = var.unique_id
}

resource "azurerm_ip_group" "this" {
  for_each = var.ip_groups

  # Intentional literal name (not via modules/naming): embeds the caller-supplied
  # map key. "ipg" is a local convention — PENDING(TDA): no approved abbreviation.
  name                = "ipg-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location
  cidrs               = each.value.cidrs
  tags                = var.tags
}

resource "azurerm_firewall_policy" "this" {
  name                     = module.policy_name.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = var.sku
  threat_intelligence_mode = var.threat_intelligence_mode
  tags                     = var.tags

  dynamic "dns" {
    for_each = var.dns == null ? [] : [var.dns]
    content {
      proxy_enabled = dns.value.proxy_enabled
      servers       = dns.value.servers
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "this" {
  for_each = var.rule_collection_groups

  name               = each.key
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = each.value.priority

  dynamic "network_rule_collection" {
    for_each = each.value.network_rule_collections
    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.key
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          source_ip_groups      = [for k in rule.value.source_ip_group_keys : azurerm_ip_group.this[k].id]
          destination_addresses = rule.value.destination_addresses
          destination_ip_groups = [for k in rule.value.destination_ip_group_keys : azurerm_ip_group.this[k].id]
          destination_fqdns     = rule.value.destination_fqdns
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = each.value.application_rule_collections
    content {
      name     = application_rule_collection.key
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name              = rule.key
          source_addresses  = rule.value.source_addresses
          source_ip_groups  = [for k in rule.value.source_ip_group_keys : azurerm_ip_group.this[k].id]
          destination_fqdns = rule.value.destination_fqdns
          destination_urls  = rule.value.destination_urls

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}
