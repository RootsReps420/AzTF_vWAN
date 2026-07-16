# Basic example — build the merged tag map for a workload.

module "tags" {
  source = "../.."

  workload    = "vdi-mult"
  environment = "prod"
  region      = "uksouth"

  mandatory = {
    cost_centre         = "CC-4821"
    owner               = "avd-platform@example.com"
    data_classification = "Internal"
    service_criticality = "Gold"
  }

  additional = {
    "cost-optimisation" = "auto-shutdown"
  }
}

output "tags" {
  value = module.tags.tags
}
