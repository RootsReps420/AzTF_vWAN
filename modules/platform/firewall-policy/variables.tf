variable "name" {
  description = "Descriptor for the firewall policy (e.g. \"hub01\"). Used as the description segment when generating the name via modules/naming."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group into which the firewall policy and IP groups are deployed."
  type        = string
}

variable "location" {
  description = "Azure region for all resources in this module."
  type        = string
}

# ---------------------------------------------------------------------------
# Naming inputs — passed through to modules/naming
# ---------------------------------------------------------------------------

variable "subscription_id" {
  description = "Subscription/landing-zone segment used to name the firewall policy (e.g. \"conn\")."
  type        = string
}

variable "environment" {
  description = "Environment segment used to name the firewall policy (e.g. \"dev\", \"prod\")."
  type        = string
}

variable "unique_id" {
  description = "Optional uniqueness/instance suffix used when naming the firewall policy (e.g. \"01\")."
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# Policy configuration
# ---------------------------------------------------------------------------

variable "sku" {
  description = "Firewall policy SKU. One of: Standard, Premium. Must match the hub firewall SKU tier."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.sku)
    error_message = "sku must be either Standard or Premium."
  }
}

variable "threat_intelligence_mode" {
  description = "Threat intelligence mode. One of: Off, Alert, Deny."
  type        = string
  default     = "Alert"

  validation {
    condition     = contains(["Off", "Alert", "Deny"], var.threat_intelligence_mode)
    error_message = "threat_intelligence_mode must be one of: Off, Alert, Deny."
  }
}

variable "dns" {
  description = "Optional DNS settings for the policy. proxy_enabled turns on DNS proxy; servers is an optional list of custom DNS servers. Null leaves DNS settings unset."
  type = object({
    proxy_enabled = optional(bool, true)
    servers       = optional(list(string), [])
  })
  default = null
}

variable "ip_groups" {
  description = "IP Groups to create, keyed by short name (becomes ipg-<key>). Each holds a list of CIDRs. Reference them from rules via source_ip_group_keys / destination_ip_group_keys."
  type = map(object({
    cidrs = list(string)
  }))
  default = {}
}

variable "rule_collection_groups" {
  description = <<-EOT
    Rule collection groups keyed by name. Each group has a priority and any number
    of network / application rule collections (keyed by collection name — follow
    TDA §10: {allow|deny}-{environment}-{service}-{description}). Rules are keyed by
    rule name ({inbound|outbound}-{description}). IP groups are referenced by their
    key in var.ip_groups, resolved to resource IDs automatically.
  EOT
  type = map(object({
    priority = number
    network_rule_collections = optional(map(object({
      priority = number
      action   = string # Allow | Deny
      rules = map(object({
        protocols                 = list(string) # TCP | UDP | ICMP | Any
        source_addresses          = optional(list(string), [])
        source_ip_group_keys      = optional(list(string), [])
        destination_addresses     = optional(list(string), [])
        destination_ip_group_keys = optional(list(string), [])
        destination_fqdns         = optional(list(string), [])
        destination_ports         = list(string)
      }))
    })), {})
    application_rule_collections = optional(map(object({
      priority = number
      action   = string # Allow | Deny
      rules = map(object({
        source_addresses     = optional(list(string), [])
        source_ip_group_keys = optional(list(string), [])
        destination_fqdns    = optional(list(string), [])
        destination_urls     = optional(list(string), [])
        protocols = optional(list(object({
          type = string # Http | Https | Mssql
          port = number
        })), [])
      }))
    })), {})
  }))
  default = {}
}

variable "tags" {
  description = "Merged tag map (output of modules/tags) applied to all resources."
  type        = map(string)
  default     = {}
}
