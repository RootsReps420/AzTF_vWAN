output "pooled_hostpool_id" {
  description = "Resource ID of the Pooled host pool."
  value       = module.hostpool_pooled.hostpool_id
}

output "pooled_registration_token" {
  description = "Registration token for the Pooled host pool (sensitive)."
  value       = module.hostpool_pooled.registration_token
  sensitive   = true
}

output "personal_hostpool_id" {
  description = "Resource ID of the Personal host pool."
  value       = module.hostpool_personal.hostpool_id
}

output "personal_registration_token" {
  description = "Registration token for the Personal host pool (sensitive)."
  value       = module.hostpool_personal.registration_token
  sensitive   = true
}
