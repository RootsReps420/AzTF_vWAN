variable "resource_type" {
  description = "Friendly resource-type slug to name (e.g. \"virtual_network\", \"key_vault\", \"storage_account\"). Mapped to the bank abbreviation internally. See README for the full list. Plan fails on an unknown value."
  type        = string
}

variable "location" {
  description = "Azure region (e.g. \"uksouth\", \"italynorth\", \"spaincentral\"). Mapped to a region short code and used as the first segment of the name. Plan fails on an unknown region."
  type        = string
}

variable "subscription_id" {
  description = "Subscription segment embedded in the name (e.g. \"conn\", \"psv-dev-vdi-01\"). For Managed Identity names this carries the service short name (e.g. \"psv\"/\"ssv\"). Not used by Key Vault or Storage Account patterns, which use the environment segment instead."
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment segment (e.g. \"dev\", \"prod\", \"pd1\"). Used by the Key Vault, Storage Account and Managed Identity patterns."
  type        = string
  default     = ""
}

variable "description" {
  description = "Short workload/purpose descriptor embedded in the name (e.g. \"hub01\", \"fslogix\")."
  type        = string
  default     = ""
}

variable "unique_id" {
  description = "Optional uniqueness/instance suffix (e.g. \"01\", or a 7-char id for Key Vault). Omitted from the name when empty."
  type        = string
  default     = ""
}
