# Basic example — a firewall policy with an IP group and one network rule
# collection group allowing outbound DNS from a spoke range.

module "firewall_policy" {
  source = "../.."

  name                = "hub01"
  resource_group_name = "rg-conn-hub01-dev"
  location            = "uksouth"
  subscription_id     = "conn"
  environment         = "dev"
  unique_id           = "01"

  sku                      = "Standard"
  threat_intelligence_mode = "Alert"

  dns = {
    proxy_enabled = true
    servers       = []
  }

  ip_groups = {
    pers-spokes = { cidrs = ["10.10.0.0/16"] }
  }

  rule_collection_groups = {
    "rcg-baseline" = {
      priority = 200
      network_rule_collections = {
        "allow-dev-plt-baseline" = {
          priority = 100
          action   = "Allow"
          rules = {
            "outbound-dns" = {
              protocols                 = ["UDP"]
              source_ip_group_keys      = ["pers-spokes"]
              destination_addresses     = ["168.63.129.16"]
              destination_ports         = ["53"]
              destination_ip_group_keys = []
            }
          }
        }
      }
    }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "policy_id" {
  value = module.firewall_policy.policy_id
}
