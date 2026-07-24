variable "azure_subscription_id" {
  description = "Azure subscription GUID for the connectivity scope (hubs, firewall, VPN)."
  type        = string
}

variable "location" {
  type    = string
  default = "uksouth"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "subscription_code" {
  type    = string
  default = "conn"
}

variable "virtual_wan_id" {
  description = "Resource ID of the shared Virtual WAN."
  type        = string
}

variable "mandatory_tags" {
  type = object({
    costCentre             = string
    securityClassification = string
    resourceOwner          = string
    CMDB_AppID             = string
  })
}

# Legacy platform params/prd/config.yml — net_hub_01_vnetAddressSpace
variable "hub01_address_prefix" {
  type    = string
  default = "10.170.247.0/24"
}

# TODO(deploy): confirm Hub02 CIDR with network team.
variable "hub02_address_prefix" {
  type    = string
  default = "10.170.248.0/24"
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.19.96.1", "10.19.97.1"]
}

variable "expressroute_circuit_peering_id" {
  type    = string
  default = null
}
