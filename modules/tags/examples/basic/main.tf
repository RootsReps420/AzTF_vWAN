module "tags" {
  source = "../.."

  workload    = "vdi-platform"
  environment = "dev"
  region      = "uksouth"

  mandatory = {
    costCentre             = "CC-4821"
    securityClassification = "Internal"
    resourceOwner          = "avd-platform@example.com"
    CMDB_AppID             = "APP-12345"
  }

  additional = {
    cost_centre_extra = "demo-only"
  }
}

output "tags" {
  value = module.tags.tags
}
