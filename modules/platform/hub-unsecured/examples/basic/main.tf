# Basic example — deploy Hub02 (unsecured) with a VPN gateway attached to an
# existing Virtual WAN.

module "hub_unsecured" {
  source = "../.."

  name                = "hub02"
  resource_group_name = "rg-conn-hub02-dev"
  location            = "uksouth"
  subscription_id     = "conn"
  environment         = "dev"
  unique_id           = "02"

  virtual_wan_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-global-prod/providers/Microsoft.Network/virtualWans/uks-conn-vwn-vdi-01" # EXAMPLE ONLY: real vWAN id
  address_prefix = "10.1.0.0/23"

  vpn = {
    scale_unit         = 1
    routing_preference = "Microsoft Network"
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "hub_id" {
  value = module.hub_unsecured.hub_id
}

output "vpn_gateway_id" {
  value = module.hub_unsecured.vpn_gateway_id
}
