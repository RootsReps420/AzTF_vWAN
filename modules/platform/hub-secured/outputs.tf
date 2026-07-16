output "hub_id" {
  description = "Resource ID of the secured virtual hub. Consumed by spoke modules for hub connections."
  value       = azurerm_virtual_hub.this.id
}

output "firewall_id" {
  description = "Resource ID of the hub Azure Firewall."
  value       = azurerm_firewall.this.id
}

output "firewall_private_ip" {
  description = "Private IP address of the hub Azure Firewall. Consumed by spoke modules for UDR configuration where explicit routing is required."
  value       = azurerm_firewall.this.virtual_hub[0].private_ip_address
}

output "express_route_gateway_id" {
  description = "Resource ID of the ExpressRoute Gateway attached to the hub."
  value       = azurerm_express_route_gateway.this.id
}
