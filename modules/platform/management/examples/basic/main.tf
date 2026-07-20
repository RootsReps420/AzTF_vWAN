# Basic example — observability platform with a workspace, a data collection
# endpoint, an AVD Insights DCR, and an action group.

module "management" {
  source = "../.."

  name                = "vdi"
  resource_group_name = "rg-conn-mgmt-dev"
  location            = "uksouth"
  subscription_id     = "conn"
  environment         = "dev"
  unique_id           = "01"

  law_retention_in_days = 30

  create_data_collection_endpoint = true
  create_avd_insights_dcr         = true

  action_groups = {
    "platform-oncall" = {
      short_name = "pltoncall"
      email_receivers = {
        "primary" = { email_address = "avd-platform@example.com" } # EXAMPLE ONLY: real on-call DL/email
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

output "law_id" {
  value = module.management.law_id
}

output "avd_insights_dcr_id" {
  value = module.management.avd_insights_dcr_id
}
