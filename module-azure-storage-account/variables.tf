variable "storage_account_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be between 3-24 characters, contain only lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the storage account will be created"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
  default     = "West Europe"
}

variable "account_tier" {
  type        = string
  description = "Storage account performance tier (Standard or Premium)"
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Account tier must be either Standard or Premium."
  }
}

variable "replication_type" {
  type        = string
  description = "Storage account replication type"
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "Replication type must be one of: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  }
}

variable "account_kind" {
  type        = string
  description = "Storage account kind"
  default     = "StorageV2"

  validation {
    condition     = contains(["BlobStorage", "BlockBlobStorage", "FileStorage", "Storage", "StorageV2"], var.account_kind)
    error_message = "Account kind must be one of: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2."
  }
}

variable "min_tls_version" {
  type        = string
  description = "Minimum TLS version for the storage account"
  default     = "TLS1_2"

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "TLS version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "allow_public_access" {
  type        = bool
  description = "Allow public access to blobs and containers"
  default     = false
}

variable "shared_access_key_enabled" {
  type        = bool
  description = "Enable shared access key authentication"
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access to the storage account"
  default     = true
}

variable "blob_versioning_enabled" {
  type        = bool
  description = "Enable blob versioning"
  default     = true
}

variable "change_feed_enabled" {
  type        = bool
  description = "Enable blob change feed"
  default     = true
}

variable "change_feed_retention_days" {
  type        = number
  description = "Number of days to retain change feed data"
  default     = 7

  validation {
    condition     = var.change_feed_retention_days >= 1 && var.change_feed_retention_days <= 146000
    error_message = "Change feed retention must be between 1 and 146000 days."
  }
}

variable "last_access_time_enabled" {
  type        = bool
  description = "Enable last access time tracking"
  default     = true
}

variable "blob_delete_retention_days" {
  type        = number
  description = "Number of days to retain deleted blobs"
  default     = 7

  validation {
    condition     = var.blob_delete_retention_days >= 1 && var.blob_delete_retention_days <= 365
    error_message = "Blob delete retention must be between 1 and 365 days."
  }
}

variable "container_delete_retention_days" {
  type        = number
  description = "Number of days to retain deleted containers"
  default     = 7

  validation {
    condition     = var.container_delete_retention_days >= 1 && var.container_delete_retention_days <= 365
    error_message = "Container delete retention must be between 1 and 365 days."
  }
}

variable "cors_rules" {
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  description = "CORS rules for the storage account"
  default     = []
}


variable "network_rules_enabled" {
  type        = bool
  description = "Enable network access rules"
  default     = false
}

variable "network_rules_default_action" {
  type        = string
  description = "Default action for network rules"
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules_default_action)
    error_message = "Default action must be either Allow or Deny."
  }
}

variable "network_rules_bypass" {
  type        = list(string)
  description = "List of services to bypass network rules"
  default     = ["AzureServices"]

  validation {
    condition = alltrue([
      for service in var.network_rules_bypass :
      contains(["Logging", "Metrics", "AzureServices", "None"], service)
    ])
    error_message = "Bypass services must be from: Logging, Metrics, AzureServices, None."
  }
}

variable "allowed_ip_ranges" {
  type        = list(string)
  description = "List of allowed IP ranges for storage account access"
  default     = []
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "List of allowed subnet IDs for storage account access"
  default     = []
}


variable "identity_type" {
  type        = string
  description = "Type of managed identity for the storage account"
  default     = null

  validation {
    condition = var.identity_type == null || contains([
      "SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"
    ], var.identity_type)
    error_message = "Identity type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "identity_ids" {
  type        = list(string)
  description = "List of user assigned identity IDs"
  default     = []
}

variable "containers" {
  type = map(object({
    access_type = string
    metadata    = map(string)
  }))
  description = "Map of storage containers to create"
  default     = {}
}

variable "queues" {
  type        = list(string)
  description = "List of storage queues to create"
  default     = []
}

variable "queue_metadata" {
  type        = map(string)
  description = "Metadata for storage queues"
  default     = {}
}

variable "tables" {
  type        = list(string)
  description = "List of storage tables to create"
  default     = []
}


variable "enable_private_endpoint" {
  type        = bool
  description = "Enable private endpoint for blob storage"
  default     = false
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID for the private endpoint"
  default     = null
}

variable "private_dns_zone_id" {
  type        = string
  description = "Private DNS zone ID for the private endpoint"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags for the storage account"
  default     = {}
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags applied to all resources"
  default = {
    Environment = "dev"
    Project     = "terraform-modules"
  }
}
