output "hostpool_id" {
  description = "Resource ID of the AVD host pool. Consumed by application-group and session-host modules."
  value       = azurerm_virtual_desktop_host_pool.this.id
}

output "hostpool_name" {
  description = "Name of the AVD host pool."
  value       = azurerm_virtual_desktop_host_pool.this.name
}

output "registration_token" {
  description = "Session-host registration token. Consumed by vdi-mult session-host deployment pipelines to join VMs to the pool. Sensitive — do not log."
  value       = azurerm_virtual_desktop_host_pool_registration_info.this.token
  sensitive   = true
}

output "registration_token_expiration" {
  description = "RFC3339 timestamp at which the current registration token expires. The token rotates automatically on this cadence."
  value       = azurerm_virtual_desktop_host_pool_registration_info.this.expiration_date
}
