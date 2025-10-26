output "storage_account_name" {
  description = "Name of the created storage account"
  value       = module.storage_account.storage_account_name
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint URL"
  value       = module.storage_account.primary_blob_endpoint
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.demorg.name
}
