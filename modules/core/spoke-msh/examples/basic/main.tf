# Basic example — an MSH spoke connected to both hubs with the three-rule UDR.

module "spoke_msh" {
  source = "../.."

  name                = "msh-fin"
  resource_group_name = "rg-vdi-msh-fin-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  address_space = ["10.20.0.0/22"]

  subnets = {
    "snet-sessionhosts" = {
      address_prefixes = ["10.20.0.0/24"]
    }
  }

  hub01_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-hub01-dev/providers/Microsoft.Network/virtualHubs/uks-conn-vhb-hub01-01"
  hub02_id                  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-hub02-dev/providers/Microsoft.Network/virtualHubs/uks-conn-vhb-hub02-02"
  hub01_firewall_private_ip = "10.0.0.68"

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-mult"
    repo         = "vdi-terraform"
  }
}

output "route_table_id" {
  value = module.spoke_msh.route_table_id
}

output "subnet_ids" {
  value = module.spoke_msh.subnet_ids
}
