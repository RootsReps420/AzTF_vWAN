# Basic example — deploy the global Virtual WAN.

module "vwan" {
  source = "../.."

  resource_group_name = "rg-conn-global-prod"
  location            = "uksouth"
  sku                 = "Standard"

  subscription_id = "conn"
  environment     = "prod"
  description     = "vdi"
  unique_id       = "01"

  tags = {
    "managed-by" = "terraform"
    environment  = "prod"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "vwan_id" {
  value = module.vwan.vwan_id
}

output "vwan_name" {
  value = module.vwan.vwan_name
}
