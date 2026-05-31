output "publicIP" {
  value = azurerm_linux_virtual_machine.workstation.public_ip_address
}