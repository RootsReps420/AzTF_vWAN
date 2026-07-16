# ---------------------------------------------------------------------------
# Naming — TDA ARN Naming Standard v2
#
# Pure computation module. Given a resource type, region, subscription code,
# environment, description and (optional) unique id, it returns the correct
# bank-compliant resource name.
#
# Every other module in this repo calls this module to name its resources —
# names are never hardcoded or typed by engineers.
#
# Different resource families follow different patterns:
#   - default          : hyphenated,  e.g. net-conn-hub01-prod-uks-01
#   - Storage Account  : no separators, lowercased, alnum only, <= 24 chars
#   - Key Vault        : hyphenated, lowercased, <= 24 chars
#   - Managed Identity : hyphenated, no unique-id segment
# ---------------------------------------------------------------------------

locals {
  # Resource type (friendly slug) -> bank abbreviation.
  # See README for the authoritative TDA ARN v2 list.
  abbreviations = {
    virtual_wan                = "vwn"
    virtual_hub                = "vhb"
    virtual_hub_connection     = "vhc"
    azure_firewall             = "afw"
    firewall_policy            = "fwp"
    expressroute_gateway       = "erg"
    vpn_gateway                = "vpg"
    virtual_network            = "net"
    network_security_group     = "nsg"
    route_table                = "rte"
    network_watcher            = "ntw"
    key_vault                  = "kvt"
    storage_account            = "sta"
    fslogix_storage_account    = "fsa"
    log_analytics_workspace    = "law"
    action_group               = "mag"
    metric_alert               = "maa"
    log_alert                  = "mma"
    defender_for_cloud         = "mdc"
    compute_gallery            = "gal"
    image_definition           = "img"
    managed_identity           = "msi"
    resource_group             = "rsg"
    public_ip                  = "pip"
    application_security_group = "asg"
  }

  # Azure region -> region short code.
  region_short = {
    uksouth      = "uks"
    ukwest       = "ukw"
    italynorth   = "itn"
    spaincentral = "spc"
    northeurope  = "neu"
    westeurope   = "weu"
  }

  # Resource types that require a special naming pattern.
  storage_types  = ["storage_account", "fslogix_storage_account"]
  keyvault_types = ["key_vault"]
  identity_types = ["managed_identity"]

  # Safe lookups (default ""). The clear error surfaces via the preconditions
  # on terraform_data.validation below, not from an index-out-of-range panic.
  abbreviation = lookup(local.abbreviations, var.resource_type, "")
  region_code  = lookup(local.region_short, var.location, "")

  # Ordered name segments shared by the hyphenated patterns.
  base_segments = [
    local.abbreviation,
    var.subscription_id,
    var.description,
    var.environment,
    local.region_code,
    var.unique_id,
  ]

  # Pattern: default — hyphenated, all segments.
  default_name = join("-", compact(local.base_segments))

  # Pattern: managed identity — hyphenated, no unique-id segment.
  identity_name = join("-", compact([
    local.abbreviation,
    var.subscription_id,
    var.description,
    var.environment,
    local.region_code,
  ]))

  # Pattern: key vault — hyphenated, lowercased, capped at 24 chars.
  keyvault_raw  = lower(join("-", compact(local.base_segments)))
  keyvault_name = substr(local.keyvault_raw, 0, min(24, length(local.keyvault_raw)))

  # Pattern: storage account — lowercased, alphanumeric only, capped at 24.
  storage_raw   = lower(join("", compact(local.base_segments)))
  storage_clean = replace(local.storage_raw, "/[^a-z0-9]/", "")
  storage_name  = substr(local.storage_clean, 0, min(24, length(local.storage_clean)))

  name = (
    contains(local.storage_types, var.resource_type) ? local.storage_name :
    contains(local.keyvault_types, var.resource_type) ? local.keyvault_name :
    contains(local.identity_types, var.resource_type) ? local.identity_name :
    local.default_name
  )
}

# Fails `terraform plan` with a clear message on an unknown region or resource
# type, rather than emitting a malformed name.
resource "terraform_data" "validation" {
  input = local.name

  lifecycle {
    precondition {
      condition     = contains(keys(local.abbreviations), var.resource_type)
      error_message = "Unknown resource_type '${var.resource_type}'. Valid types: ${join(", ", sort(keys(local.abbreviations)))}."
    }

    precondition {
      condition     = contains(keys(local.region_short), var.location)
      error_message = "Unknown location '${var.location}'. Valid regions: ${join(", ", sort(keys(local.region_short)))}."
    }
  }
}
