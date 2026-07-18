# Basic example — a PERS spoke with a single session-host subnet connected to
# Hub01.

module "spoke_pers" {
  source = "../.."

  name                = "pers-lab01"
  resource_group_name = "rg-vdi-pers-lab01-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  address_space = ["10.10.0.0/22"]

  subnets = {
    "snet-sessionhosts" = {
      address_prefixes = ["10.10.0.0/24"]
      security_rules = {
        "inbound-deny-internet" = {
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "Internet"
          destination_address_prefix = "*"
        }
      }
    }
  }

  hub01_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-hub01-dev/providers/Microsoft.Network/virtualHubs/uks-conn-vhb-hub01-01"

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-pers"
    repo         = "vdi-terraform"
  }
}

output "subnet_ids" {
  value = module.spoke_pers.subnet_ids
}
