output "vm_public_ip" {
  description = "Public IP of DC1 — RDP to this address."
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_private_ip" {
  description = "Static private IP of DC1 (used as the DNS server for the domain)."
  value       = azurerm_network_interface.nic.private_ip_address
}

output "admin_username" {
  description = "Username for RDP login."
  value       = azurerm_windows_virtual_machine.dc1.admin_username
}

output "resource_group_name" {
  description = "Resource group containing the lab."
  value       = azurerm_resource_group.rg.name
}

output "rdp_command" {
  description = "Paste this into a terminal (Windows) to launch RDP."
  value       = "mstsc /v:${azurerm_public_ip.pip.ip_address}"
}