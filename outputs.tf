output "resource_group" {
  value = azurerm_resource_group.anne_terraform_rg.name
}

output "location" {
  value = azurerm_resource_group.anne_terraform_rg.location
}

output "lb_publicip" {
  value = azurerm_public_ip.anne_terraform_lbip.id
}

output "private_ip_vm1" {
  value = azurerm_network_interface.anne_terraform_ni[0].private_ip_address
}

output "private_ip_vm2" {
  value = azurerm_network_interface.anne_terraform_ni[1].private_ip_address
}

