variable "name" {
  description = "Descriptor for the Key Vault (e.g. \"lab01\"). Used as the description segment in the KV name pattern ({region}-{env}-kvt-{id})."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "Name of the resource group into which the Key Vault is deployed."
  type        = string
}

variable "location" {
  description = "Azure region for the Key Vault."
  type        = string
}

# ---------------------------------------------------------------------------
# Naming inputs
# ---------------------------------------------------------------------------

variable "subscription_id" {
  description = "Subscription/landing-zone segment (not used by the KV name pattern, kept for module consistency)."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment segment used in the KV name (e.g. \"dev\", \"prod\")."
  type        = string
}

variable "unique_id" {
  description = "Uniqueness id for the KV name (the 7-char id segment, e.g. \"lab01a1\"). Key Vault names are globally unique."
  type        = string
}

# ---------------------------------------------------------------------------
# Key Vault
# ---------------------------------------------------------------------------

variable "tenant_id" {
  description = "Azure AD tenant ID for the Key Vault. Defaults to the current client tenant when null."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "Key Vault SKU. One of: standard, premium."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "sku_name must be either standard or premium."
  }
}

variable "purge_protection_enabled" {
  description = "Enable purge protection. Required when the vault holds CMKs used by other services."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "Soft-delete retention in days (7-90)."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }
}

variable "public_network_access_enabled" {
  description = "Whether the vault is reachable from public networks. Set false when fronted by a private endpoint."
  type        = bool
  default     = false
}

variable "network_acls" {
  description = "Optional network ACLs for the vault."
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = null
}

# ---------------------------------------------------------------------------
# Keys / secrets / RBAC
# ---------------------------------------------------------------------------

variable "keys" {
  description = "CMK keys keyed by key name."
  type = map(object({
    key_type = optional(string, "RSA")
    key_size = optional(number, 2048)
    curve    = optional(string)
    key_opts = optional(list(string), ["unwrapKey", "wrapKey"])
    rotation_policy = optional(object({
      expire_after         = string
      notify_before_expiry = string
      time_before_expiry   = string
    }))
  }))
  default = {}
}

variable "secrets" {
  description = "Secrets keyed by secret name -> value. Values flow into azurerm_key_vault_secret.value, which the provider marks sensitive (redacted in plan output)."
  type        = map(string)
  default     = {}
}

variable "role_assignments" {
  description = "RBAC role assignments keyed by descriptor. scope defaults to the Key Vault when null."
  type = map(object({
    role_definition_name = string
    principal_id         = string
    scope                = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Merged tag map (output of modules/tags) applied to the Key Vault."
  type        = map(string)
  default     = {}
}
