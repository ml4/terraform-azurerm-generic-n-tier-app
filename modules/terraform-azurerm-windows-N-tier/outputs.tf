//// networking related
//
output "windows_app_startup_script" {
  value       = var.app ? data.template_file.app_startup_script.rendered : ""
  description = "startup script when instance boots"
}

output "database_startup_script" {
  value       = var.database ? data.template_file.database_startup_script.rendered : ""
  description = "startup script when instance boots"
}

output "web_startup_script" {
  value       = var.web ? data.template_file.web_startup_script.rendered : ""
  description = "startup script when instance boots"
}

output "network_subnet_id" {
  value       = azurerm_subnet.networking[*].id
  description = "VNet subnet ID(s)"
}

//// win vm related
//
output "winvm-web-public_ip_address" {
  value       = azurerm_windows_virtual_machine.web.public_ip_address
  description = "Azure Win VM: Azure Win VM Web Server public IP address"
}

// output "winvm-app-public_ip_address" {
//   value       = azurerm_windows_virtual_machine.app.public_ip_address
//   description = "Azure Win VM: Azure Win VM App Server public IP address"
// }

// output "winvm-db-public_ip_address" {
//   value       = azurerm_windows_virtual_machine.db.public_ip_address
//   description = "Azure Win VM: Azure Win VM DB Server public IP address"
// }
