variable "name" {
  description = "Descriptor for the workspace (e.g. \"vdi-fin\"). Used as the description segment when generating names via modules/naming."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group into which the workspace and app groups are deployed."
  type        = string
}

variable "location" {
  description = "Azure region for all resources in this module."
  type        = string
}

# ---------------------------------------------------------------------------
# Naming inputs
# ---------------------------------------------------------------------------

variable "subscription_id" {
  description = "Subscription/landing-zone segment used to name the resources (e.g. \"vdi\")."
  type        = string
}

variable "environment" {
  description = "Environment segment used to name the resources (e.g. \"dev\", \"prod\")."
  type        = string
}

variable "unique_id" {
  description = "Optional uniqueness/instance suffix used when naming the workspace (e.g. \"01\")."
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# Workspace + application groups
# ---------------------------------------------------------------------------

variable "friendly_name" {
  description = "Display name of the workspace shown to users in the AVD client."
  type        = string
  default     = null
}

variable "description" {
  description = "Free-text description of the workspace."
  type        = string
  default     = null
}

variable "application_groups" {
  description = <<-EOT
    Application groups keyed by descriptor. type is Desktop or RemoteApp; host_pool_id
    is the pool the group is backed by. Each group is associated with the workspace.
  EOT
  type = map(object({
    host_pool_id                 = string
    type                         = string # Desktop | RemoteApp
    friendly_name                = optional(string)
    description                  = optional(string)
    default_desktop_display_name = optional(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for ag in values(var.application_groups) : contains(["Desktop", "RemoteApp"], ag.type)])
    error_message = "Each application group type must be Desktop or RemoteApp."
  }
}

variable "tags" {
  description = "Merged tag map (output of modules/tags) applied to all resources."
  type        = map(string)
  default     = {}
}
