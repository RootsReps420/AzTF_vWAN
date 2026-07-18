output "law_id" {
  description = "Resource ID of the regional Log Analytics workspace."
  value       = module.management.law_id
}

output "hub01_id" {
  description = "Resource ID of Hub01 (secured hub)."
  value       = module.hub_secured.hub_id
}

output "hub01_firewall_private_ip" {
  description = "Private IP of the Hub01 Azure Firewall."
  value       = module.hub_secured.firewall_private_ip
}

output "hub02_id" {
  description = "Resource ID of Hub02 (unsecured hub)."
  value       = module.hub_unsecured.hub_id
}

output "pers_spoke_subnet_ids" {
  description = "PERS lab spoke subnet IDs."
  value       = module.spoke_pers.subnet_ids
}

output "msh_spoke_subnet_ids" {
  description = "MSH lab spoke subnet IDs."
  value       = module.spoke_msh.subnet_ids
}

output "gallery_id" {
  description = "Resource ID of the AVD compute gallery."
  value       = module.gallery.gallery_id
}

output "image_definition_ids" {
  description = "Image definition IDs (PERS + MSH base)."
  value = {
    pers     = module.image_pers.image_definition_id
    msh_base = module.image_msh_base.image_definition_id
  }
}
