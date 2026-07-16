output "name" {
  description = "Bank-compliant resource name for the requested resource type."
  value       = local.name
}

output "abbreviation" {
  description = "Bank abbreviation resolved for the requested resource type (e.g. \"net\" for virtual_network)."
  value       = local.abbreviation
}

output "region_short" {
  description = "Region short code resolved for the requested Azure region (e.g. \"uks\" for uksouth)."
  value       = local.region_code
}
