variable "resource_type" {
  description = "Friendly resource-type slug to name (e.g. \"virtual_network\", \"key_vault\", \"storage_account\"). Mapped to the bank abbreviation internally. See README for the full list. Plan fails on an unknown value."
  type        = string
}

variable "location" {
  description = "Azure region (e.g. \"uksouth\", \"italynorth\", \"spaincentral\"). Mapped to a region short code. Plan fails on an unknown region."
  type        = string
}

variable "subscription_id" {
  description = "Short subscription identifier / landing-zone code embedded in the name (e.g. \"conn\", \"vdi\")."
  type        = string
}

variable "environment" {
  description = "Environment segment (e.g. \"dev\", \"prod\")."
  type        = string
}

variable "description" {
  description = "Short workload/purpose descriptor embedded in the name (e.g. \"hub01\", \"fslogix\")."
  type        = string
}

variable "unique_id" {
  description = "Optional uniqueness/instance suffix (e.g. \"01\"). Omitted from the name when empty; never used for Managed Identity names."
  type        = string
  default     = ""
}
