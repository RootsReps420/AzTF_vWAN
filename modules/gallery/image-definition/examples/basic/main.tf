# Basic example — the two AVD image definitions (PERS and MSH base) in one
# gallery. Instantiate this module once per definition.

module "image_pers" {
  source = "../.."

  name                = "pers-win11"
  gallery_name        = "uks_vdi_gal_avd_01"
  resource_group_name = "rg-vdi-images-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"

  os_type       = "Windows"
  security_type = "TrustedLaunch"

  identifier = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-23h2-avd-pers"
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-pers"
    repo         = "vdi-terraform"
  }
}

module "image_msh_base" {
  source = "../.."

  name                = "msh-win11-base"
  gallery_name        = "uks_vdi_gal_avd_01"
  resource_group_name = "rg-vdi-images-dev"
  location            = "uksouth"
  subscription_id     = "vdi"
  environment         = "dev"

  os_type       = "Windows"
  security_type = "TrustedLaunch"

  identifier = {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-23h2-avd-msh-base"
  }

  tags = {
    "managed-by" = "terraform"
    environment  = "dev"
    workload     = "vdi-mult"
    repo         = "vdi-terraform"
  }
}

output "image_definition_ids" {
  value = {
    pers     = module.image_pers.image_definition_id
    msh_base = module.image_msh_base.image_definition_id
  }
}
