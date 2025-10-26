resource "azurerm_storage_account" "sa" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.replication_type
  account_kind                    = var.account_kind
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_public_access
  shared_access_key_enabled       = var.shared_access_key_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  https_traffic_only_enabled      = true

  blob_properties {
    versioning_enabled            = var.blob_versioning_enabled
    change_feed_enabled           = var.change_feed_enabled
    change_feed_retention_in_days = var.change_feed_retention_days
    last_access_time_enabled      = var.last_access_time_enabled

    delete_retention_policy {
      days = var.blob_delete_retention_days
    }

    container_delete_retention_policy {
      days = var.container_delete_retention_days
    }

    dynamic "cors_rule" {
      for_each = var.cors_rules
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }

  # Network access rules
  dynamic "network_rules" {
    for_each = var.network_rules_enabled ? [1] : []
    content {
      default_action             = var.network_rules_default_action
      bypass                     = var.network_rules_bypass
      ip_rules                   = var.allowed_ip_ranges
      virtual_network_subnet_ids = var.allowed_subnet_ids
    }
  }

  # Identity configuration for managed identity
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_ids
    }
  }

  # Apply tags
  tags = merge(
    var.default_tags,
    var.tags,
    {
      "ManagedBy" = "Terraform"
    }
  )

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      # Ignore changes to tags that might be applied externally
      tags["CreatedDate"],
    ]
  }
}

# Storage containers
resource "azurerm_storage_container" "containers" {
  for_each = var.containers

  name                  = each.key
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = each.value.access_type

  metadata = each.value.metadata
}

# Storage queues
resource "azurerm_storage_queue" "queues" {
  for_each = toset(var.queues)

  name               = each.value
  storage_account_id = azurerm_storage_account.sa.id

  metadata = var.queue_metadata
}

# Storage tables
resource "azurerm_storage_table" "tables" {
  for_each = toset(var.tables)

  name                 = each.value
  storage_account_name = azurerm_storage_account.sa.name
}

# Private endpoint for enhanced security
resource "azurerm_private_endpoint" "blob_endpoint" {
  count = var.enable_private_endpoint ? 1 : 0

  name                = "${var.storage_account_name}-blob-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.storage_account_name}-blob-psc"
    private_connection_resource_id = azurerm_storage_account.sa.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "blob-dns-zone-group"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }

  tags = var.tags
}
