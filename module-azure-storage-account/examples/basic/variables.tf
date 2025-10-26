variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-storage-example"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "West Europe"
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage account name must be between 3-24 characters, contain only lowercase letters and numbers."
  }
}
