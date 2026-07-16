variable "azure_subscription_id" {
  description = "Azure subscription GUID the connectivity/global resources are deployed into."
  type        = string
}

variable "subscription_code" {
  description = "Short subscription / landing-zone code used in resource names (e.g. \"conn\")."
  type        = string
  default     = "conn"
}

variable "environment" {
  description = "Environment segment for the global resources."
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Home region for the global Virtual WAN."
  type        = string
  default     = "uksouth"
}

variable "mandatory_tags" {
  description = "Mandatory bank tags applied to all global resources (see modules/tags)."
  type = object({
    cost_centre         = string
    owner               = string
    data_classification = string
    service_criticality = string
  })
}
