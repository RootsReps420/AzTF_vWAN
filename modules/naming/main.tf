# ---------------------------------------------------------------------------
# Naming — TDA ARN Naming Standard v2
#
# Pure computation module. Given a resource type, region, subscription segment,
# environment, description and (optional) unique id, it returns the correct
# bank-compliant resource name.
#
# Every other module in this repo calls this module to name its resources —
# names are never hardcoded or typed by engineers.
#
# Segment order follows the TDA standard (region first):
#   - default          : {region}-{subscription}-{abbr}-{description}-{unique_id}
#                        e.g. uks-psv-dev-vdi-01-afw-hub01   (TDA §9.2 / LLD §5)
#   - resource group   : default pattern with abbr "rsg"     (TDA §9.1)
#   - key vault        : {region}-{environment}-kvt-{id}      (TDA §11.1)
#   - storage account  : {region}{environment}{abbr}{desc}{id} no separators,
#                        lowercased, alnum only, <= 24 chars  (TDA §9.3)
#   - managed identity : {subscription}-{environment}-msi-{description}-{id}
#                        (subscription segment = service)     (TDA §13.5)
#   - compute gallery  : underscore-joined (Azure disallows hyphens in gallery
#                        names)
# ---------------------------------------------------------------------------

locals {
  # Resource type (friendly slug) -> bank abbreviation (TDA ARN v2 §5).
  # See README for the authoritative list. Items flagged PENDING are awaiting
  # TDA sign-off (LLD Open Item 2) — abbreviation may change on approval.
  abbreviations = {
    # Networking
    virtual_wan                = "vwn"
    virtual_hub                = "vhb"
    virtual_hub_connection     = "vhc"
    azure_firewall             = "afw"
    firewall_policy            = "fwp"
    ip_group                   = "ipg" # PENDING — no TDA abbreviation defined
    expressroute_gateway       = "erg"
    expressroute_connection    = "erc"
    expressroute_circuit       = "ert"
    vpn_gateway                = "vpg"
    virtual_network            = "net"
    network_interface          = "nic"
    network_security_group     = "nsg"
    route_table                = "rte"
    route_filter               = "rtf"
    network_watcher            = "ntw"
    public_ip                  = "pip"
    private_endpoint           = "pen"
    private_dns_zone           = "pdz"
    private_dns                = "dns"
    vnet_peering               = "prg"
    application_security_group = "asg"

    # Storage / data
    storage_account         = "sta"
    fslogix_storage_account = "fsa"
    blob_storage_account    = "blb"

    # Security / identity
    key_vault          = "kvt"
    managed_identity   = "msi"
    managed_user_id    = "mui"
    disk_encryption    = "des"
    azure_role         = "azrole"
    ad_role            = "adrole"
    app_registration   = "appreg"
    authorization_lock = "lck"

    # Observability (TDA §5)
    log_analytics_workspace  = "law"
    data_collection_rule     = "mdc" # Monitor Data Collection Rule
    data_collection_endpoint = "dce" # PENDING TDA sign-off
    action_group             = "mag" # Monitor Action Group
    activity_log_alert       = "maa" # Monitor Activity Alert
    metric_alert             = "mma" # Monitor Metric Alert
    scheduled_query_alert    = "sqr" # PENDING TDA sign-off
    workbook                 = "wkb" # PENDING TDA sign-off

    # Compute / images
    compute_gallery  = "gal"
    image_definition = "img"

    # AVD (all PENDING TDA sign-off — LLD Open Item 2)
    avd_host_pool         = "vdhp"
    avd_workspace         = "vdws"
    avd_application_group = "vdag"
    avd_scaling_plan      = "vdsp"

    # Structure
    resource_group = "rsg"
  }

  # Azure region -> region short code. itn/spc are PENDING TDA approval
  # (LLD Open Item 1).
  region_short = {
    uksouth      = "uks"
    ukwest       = "ukw"
    italynorth   = "itn" # PENDING TDA approval
    spaincentral = "spc" # PENDING TDA approval
    northeurope  = "neu"
    westeurope   = "weu"
  }

  # Resource families that require a special naming pattern.
  storage_types  = ["storage_account", "fslogix_storage_account", "blob_storage_account"]
  keyvault_types = ["key_vault"]
  identity_types = ["managed_identity", "managed_user_id"]
  gallery_types  = ["compute_gallery"]

  # Safe lookups (default ""). Clear errors surface via the preconditions on
  # terraform_data.validation below, not from an index-out-of-range panic.
  abbreviation = lookup(local.abbreviations, var.resource_type, "")
  region_code  = lookup(local.region_short, var.location, "")

  # Pattern: default — {region}-{subscription}-{abbr}-{description}-{unique_id}
  default_name = join("-", compact([
    local.region_code,
    var.subscription_id,
    local.abbreviation,
    var.description,
    var.unique_id,
  ]))

  # Pattern: key vault — {region}-{environment}-kvt-{description}-{id},
  # lowercased, capped at 24 chars.
  keyvault_raw = lower(join("-", compact([
    local.region_code,
    var.environment,
    local.abbreviation,
    var.description,
    var.unique_id,
  ])))
  keyvault_name = substr(local.keyvault_raw, 0, min(24, length(local.keyvault_raw)))

  # Pattern: storage account — {region}{environment}{abbr}{description}{id},
  # lowercased, alphanumeric only, capped at 24 chars.
  storage_raw = lower(join("", compact([
    local.region_code,
    var.environment,
    local.abbreviation,
    var.description,
    var.unique_id,
  ])))
  storage_clean = replace(local.storage_raw, "/[^a-z0-9]/", "")
  storage_name  = substr(local.storage_clean, 0, min(24, length(local.storage_clean)))

  # Pattern: managed identity — {subscription}-{environment}-msi-{description}-{id}.
  # The subscription segment carries the service short name (e.g. psv/ssv).
  identity_name = join("-", compact([
    var.subscription_id,
    var.environment,
    local.abbreviation,
    var.description,
    var.unique_id,
  ]))

  # Pattern: compute gallery — Azure disallows hyphens in gallery names, so the
  # default segments are joined with underscores instead.
  gallery_name = join("_", compact([
    local.region_code,
    var.subscription_id,
    local.abbreviation,
    var.description,
    var.unique_id,
  ]))

  name = (
    contains(local.storage_types, var.resource_type) ? local.storage_name :
    contains(local.keyvault_types, var.resource_type) ? local.keyvault_name :
    contains(local.identity_types, var.resource_type) ? local.identity_name :
    contains(local.gallery_types, var.resource_type) ? local.gallery_name :
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
