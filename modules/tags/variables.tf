variable "mandatory" {
  description = <<-EOT
    Mandatory bank tags required by the tagging standard. Declared as a typed
    object so `terraform plan` FAILS if any required key is missing.

    Keys match the bank schema (LLD Open Item 3 resolved):
      costCentre              : Charge-back cost centre code.
      securityClassification  : Data/security classification.
      resourceOwner           : Accountable owner (team or DL).
      CMDB_AppID              : CMDB application identifier.
  EOT
  type = object({
    costCentre             = string
    securityClassification = string
    resourceOwner          = string
    CMDB_AppID             = string
  })

  validation {
    condition     = alltrue([for v in values(var.mandatory) : trimspace(v) != ""])
    error_message = "All mandatory tag values must be non-empty."
  }
}

variable "workload" {
  description = "Workload identifier applied as the `workload` tag (e.g. \"vdi-mult\", \"vdi-pers\", \"vdi-platform\")."
  type        = string

  validation {
    condition     = trimspace(var.workload) != ""
    error_message = "workload must be a non-empty string."
  }
}

variable "environment" {
  description = "Environment applied as the `environment` tag (e.g. \"dev\", \"prod\")."
  type        = string

  validation {
    condition     = trimspace(var.environment) != ""
    error_message = "environment must be a non-empty string."
  }
}

variable "region" {
  description = "Region applied as the `region` tag (e.g. \"uksouth\")."
  type        = string

  validation {
    condition     = trimspace(var.region) != ""
    error_message = "region must be a non-empty string."
  }
}

variable "additional" {
  description = "Optional workload-specific tags. Merged in at lowest precedence — cannot override mandatory or platform-standard tags."
  type        = map(string)
  default     = {}
}
