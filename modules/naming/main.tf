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
#   - default          : {region}-{subscription}-{abbr}-{description|id}   (TDA §9.2)
#   - resource group   : {region}-{subscription}-rsg-{description}         (TDA §9.1)
#   - key vault        : {region}-{environment}-{service}-kvt-{7charId}    (TDA §11.1)
#   - storage account  : {region}{environment}{service}{subscription}{id}  (TDA §9.3)
#                        no separators, lowercased, alnum only, <= 24 chars
#   - managed identity : {service}-{environment}-msi-{resource}-{description}-{id}
#                        (TDA §13.5)
#   - compute gallery  : underscore-joined (Azure disallows hyphens in gallery
#                        names) — technical exception, not a TDA pattern
#
# Marker legend used throughout this repo:
#   PENDING(TDA) : abbreviation/region not yet defined or approved in the TDA
#                  standard — value is provisional and may change on sign-off.
#   PENDING(LLD) : open design item tracked in the solution LLD.
#   TODO(deploy) : a real value an engineer must supply before deployment.
# ---------------------------------------------------------------------------

locals {
  # Resource type (friendly slug) -> TDA abbreviation (TDA ARN v2 §5).
  # Codes without a marker are confirmed in the TDA standard. Codes marked
  # PENDING(TDA) are NOT in the standard yet and are provisional.
  abbreviations = {
    # Networking
    virtual_wan                = "vwn"
    virtual_hub                = "vhb"
    virtual_hub_connection     = "vhc"
    azure_firewall             = "afw"
    firewall_policy            = "fwp"
    ip_group                   = "ipg" # PENDING(TDA): no approved abbreviation defined
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
    data_collection_endpoint = "dce" # PENDING(TDA): no approved abbreviation defined
    action_group             = "mag" # Monitor Action Group
    activity_log_alert       = "maa" # Monitor Activity Alert
    metric_alert             = "mma" # Monitor Metric Alert
    scheduled_query_alert    = "sqr" # PENDING(TDA): no approved abbreviation defined
    workbook                 = "wkb" # PENDING(TDA): no approved abbreviation defined

    # Compute / images
    compute_gallery  = "gal"
    image_definition = "img"

    # AVD — TDA defines NO AVD abbreviations yet (LLD Open Item 2). These are
    # provisional 3-letter codes chosen to satisfy the TDA §9.2 [a-z]{3} rule.
    avd_host_pool         = "vdh" # PENDING(TDA): provisional (LLD Open Item 2)
    avd_workspace         = "vdw" # PENDING(TDA): provisional (LLD Open Item 2)
    avd_application_group = "vda" # PENDING(TDA): provisional (LLD Open Item 2)
    avd_scaling_plan      = "vds" # PENDING(TDA): provisional (LLD Open Item 2)

    # Structure
    resource_group = "rsg"
  }

  # Azure region -> region short code.
  region_short = {
    # TDA-approved (TDA §2.1) — the only regions the default-name regex allows.
    uksouth = "uks"
    ukwest  = "ukw"
    # PENDING(TDA): NOT in TDA §2.1. Provisional codes — do not use for
    # production names until TDA approves (LLD Open Item 1).
    italynorth   = "itn" # PENDING(TDA): non-standard region code
    spaincentral = "spc" # PENDING(TDA): non-standard region code
    northeurope  = "neu" # PENDING(TDA): non-standard region code
    westeurope   = "weu" # PENDING(TDA): non-standard region code
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

  # Pattern: default — {region}-{subscription}-{abbr}-{description|id}  (TDA §9.2).
  # compact() drops any empty segment, so callers pass description OR unique_id
  # (or both) without producing empty "--" gaps.
  default_name = join("-", compact([
    local.region_code,
    var.subscription_id,
    local.abbreviation,
    var.description,
    var.unique_id,
  ]))

  # Pattern: key vault — {region}-{environment}-{service}-kvt-{7charId}  (TDA §11.1).
  # The "service" segment is carried by var.description; the kvt token sits AFTER
  # it (per the standard), and var.unique_id is the trailing id. Lowercased and
  # capped at the 24-char Azure Key Vault limit.
  keyvault_raw = lower(join("-", compact([
    local.region_code,
    var.environment,
    var.description, # {service}
    local.abbreviation,
    var.unique_id, # {7charId}
  ])))
  keyvault_name = substr(local.keyvault_raw, 0, min(24, length(local.keyvault_raw)))

  # Pattern: storage account — {region}{environment}{service}{subscription}{id}
  # (TDA §9.3). NOTE: the TDA storage format does NOT include a resource-type
  # abbreviation (no sta/fsa/blb in the name); the service is var.description and
  # the subscription segment is var.subscription_id. Lowercased, alphanumeric
  # only, capped at 24 chars.
  storage_raw = lower(join("", compact([
    local.region_code,
    var.environment,
    var.description,     # {service}
    var.subscription_id, # {subscription}
    var.unique_id,       # {id}
  ])))
  storage_clean = replace(local.storage_raw, "/[^a-z0-9]/", "")
  storage_name  = substr(local.storage_clean, 0, min(24, length(local.storage_clean)))

  # Pattern: managed identity —
  # {service}-{environment}-msi-{resource}-{description}-{id}  (TDA §13.5).
  # The subscription segment carries the service short name (e.g. psv/ssv); the
  # 3-letter {resource} segment (var.resource_code) identifies what the identity
  # is for.
  identity_name = join("-", compact([
    var.subscription_id, # {service}
    var.environment,
    local.abbreviation, # msi / mui
    var.resource_code,  # {resource}
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
