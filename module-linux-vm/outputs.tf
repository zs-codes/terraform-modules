output "public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.myIp.ip_address
}

output "private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.myNIC.private_ip_address
}

output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.myIp.ip_address}"
}

output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.myVM.id
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.myrg.name
}
