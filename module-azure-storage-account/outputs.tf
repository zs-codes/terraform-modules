# Storage account outputs

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.sa.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.sa.name
}
output "primary_connection_string" {
  description = "Primary connection string for the storage account"
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "Primary blob storage endpoint"
  value       = azurerm_storage_account.sa.primary_blob_endpoint
}

output "primary_queue_endpoint" {
  description = "Primary queue storage endpoint"
  value       = azurerm_storage_account.sa.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "Primary table storage endpoint"
  value       = azurerm_storage_account.sa.primary_table_endpoint
}


output "primary_file_endpoint" {
  description = "Primary file storage endpoint"
  value       = azurerm_storage_account.sa.primary_file_endpoint
}


output "identity" {
  description = "Identity information of the storage account"
  value = var.identity_type != null ? {
    type         = azurerm_storage_account.sa.identity[0].type
    principal_id = azurerm_storage_account.sa.identity[0].principal_id
    tenant_id    = azurerm_storage_account.sa.identity[0].tenant_id
  } : null
}

output "containers" {
  description = "Information about created containers"
  value = {
    for name, container in azurerm_storage_container.containers : name => {
      name                    = container.name
      id                      = container.id
      has_immutability_policy = container.has_immutability_policy
      has_legal_hold          = container.has_legal_hold
      resource_manager_id     = container.resource_manager_id
    }
  }
}


output "quick_reference" {
  description = "Quick reference information for the storage account"
  value = {
    name                = azurerm_storage_account.sa.name
    resource_group_name = azurerm_storage_account.sa.resource_group_name
    location            = azurerm_storage_account.sa.location
    account_tier        = azurerm_storage_account.sa.account_tier
    replication_type    = azurerm_storage_account.sa.account_replication_type
    account_kind        = azurerm_storage_account.sa.account_kind
    https_only          = azurerm_storage_account.sa.https_traffic_only_enabled
    min_tls_version     = azurerm_storage_account.sa.min_tls_version
  }
}
