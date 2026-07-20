variable "mandatory" {
  description = <<-EOT
    Mandatory bank tags required by the tagging standard. Declared as a typed
    object so `terraform plan` FAILS if any required key is missing.

    PENDING(LLD): placeholder keys awaiting confirmation of the authoritative
    mandatory tag schema (LLD Open Item 3). Update this object's keys (and every
    caller) once the bank standard is confirmed.
      cost_centre         : Charge-back cost centre code.
      owner               : Accountable owner (team or DL email).
      data_classification : Data classification (e.g. Public, Internal, Confidential).
      service_criticality : Service criticality tier (e.g. Bronze, Silver, Gold).
  EOT
  type = object({
    # PENDING(LLD): confirm the authoritative mandatory-tag key set (LLD Open Item 3).
    cost_centre         = string
    owner               = string
    data_classification = string
    service_criticality = string
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
