# Basic usage

```hcl
module "storage_basic" {
  source = "./module-azure-storage-account"

  storage_account_name = "mycompanystorage001"
  resource_group_name  = "rg-production"
  location            = "West Europe"

  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

# Advanced secure configuration

```hcl
module "storage_secure" {
  source = "./module-azure-storage-account"

  storage_account_name = "securestorage001"
  resource_group_name  = "rg-secure"
  location            = "West Europe"

  # Enhanced security
  account_tier     = "Standard"
  replication_type = "GRS"
  min_tls_version  = "TLS1_2"

# Network restrictions

network_rules_enabled = true
network_rules_default_action = "Deny"
allowed_ip_ranges = ["203.0.113.0/24"]

# Data protection

blob_versioning_enabled = true
blob_delete_retention_days = 30
container_delete_retention_days = 30

# Containers

containers = {
"backups" = {
access_type = "private"
metadata = {
purpose = "backup-storage"
}
}
}

# Identity

identity_type = "SystemAssigned"

tags = {
Environment = "production"
Compliance = "required"
}
}
```
