# Basic example — a compute gallery with Contributor granted to the Packer MSI.

module "gallery" {
  source = "../.."

  name                = "avd"
  resource_group_name = "rg-vdi-images-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"
  unique_id           = "01"

  description = "AVD image gallery (PERS and MSH definitions)"

  role_assignments = {
    "packer-build" = {
      role_definition_name = "Contributor"
      principal_id         = "00000000-0000-0000-0000-000000000000" # EXAMPLE ONLY: real Packer build MSI object id
    }
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-platform"
    repo         = "vdi-terraform"
  }
}

output "gallery_id" {
  value = module.gallery.gallery_id
}
