variable "resource_group_name" {
  description = "Name of the resource group into which the Virtual WAN is deployed."
  type        = string
}

variable "location" {
  description = "Azure region for the Virtual WAN resource. Virtual WAN is global, but the resource still carries a home region."
  type        = string
}

variable "sku" {
  description = "Virtual WAN SKU. One of: Basic, Standard. Standard is required for secured hubs and routing intent."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "sku must be either Basic or Standard."
  }
}

variable "tags" {
  description = "Merged tag map (output of modules/tags) applied to the Virtual WAN."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Naming inputs — passed through to modules/naming to generate the resource name
# ---------------------------------------------------------------------------

variable "subscription_id" {
  description = "Short subscription / landing-zone code used to name the Virtual WAN (e.g. \"conn\")."
  type        = string
}

variable "environment" {
  description = "Environment segment used to name the Virtual WAN (e.g. \"prod\")."
  type        = string
}

variable "description" {
  description = "Short descriptor used to name the Virtual WAN."
  type        = string
  default     = "vdi"
}

variable "unique_id" {
  description = "Optional uniqueness suffix used to name the Virtual WAN (e.g. \"01\")."
  type        = string
  default     = ""
}
