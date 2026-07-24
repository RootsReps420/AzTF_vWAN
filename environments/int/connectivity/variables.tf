# TODO(deploy): connectivity/hub subscription GUID for int.
variable "azure_subscription_id" {
  description = "Azure subscription GUID for the connectivity scope (hubs, firewall, VPN)."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
  default     = "uksouth"
}

variable "environment" {
  description = "Environment code (int = DT)."
  type        = string
  default     = "int"
}

variable "subscription_code" {
  description = "Naming segment for connectivity resources."
  type        = string
  default     = "conn"
}

# Sourced from environments/_global output vwan_id.
variable "virtual_wan_id" {
  description = "Resource ID of the shared Virtual WAN."
  type        = string
}

variable "mandatory_tags" {
  description = "Mandatory bank tags (see modules/tags)."
  type = object({
    costCentre             = string
    securityClassification = string
    resourceOwner          = string
    CMDB_AppID             = string
  })
}

# Address plan from legacy platform params/int/config.yml (verbatim).
# Virtual hub uses /23 or /24 — legacy hub VNet was /24.
variable "hub01_address_prefix" {
  description = "Hub01 (secured) virtual hub address prefix. Legacy net_hub_01_vnetAddressSpace."
  type        = string
  default     = "10.170.245.0/24"
}

# TODO(deploy): confirm Hub02 CIDR with network team (not in classic hub estate).
variable "hub02_address_prefix" {
  description = "Hub02 (unsecured) virtual hub address prefix."
  type        = string
  default     = "10.170.246.0/24"
}

variable "dns_servers" {
  description = "Corporate DNS servers (legacy p_dnsServers)."
  type        = list(string)
  default     = ["10.19.96.1", "10.19.97.1"]
}

variable "expressroute_circuit_peering_id" {
  description = "Optional ER circuit private peering ID. Null = gateway only."
  type        = string
  default     = null
}
