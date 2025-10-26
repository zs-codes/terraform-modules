# Azure Storage Account Module

This Terraform module creates a secure, enterprise-ready Azure Storage Account with comprehensive security configurations, monitoring capabilities, and flexible networking options.

## Features

### Security First

- **TLS 1.2 minimum** encryption in transit
- **Blob versioning** and **change feed** tracking
- **Soft delete** protection for blobs and containers
- **Private endpoint** support for network isolation
- **Managed identity** integration
- **Network access rules** with IP and subnet restrictions

### Storage Services

- **Blob Storage** with configurable containers
- **Queue Storage** with custom metadata
- **Table Storage** for structured data
- **File Storage** endpoints

### Production Ready

- **Input validation** for all critical parameters
- **Lifecycle management** with prevent_destroy
- **Comprehensive tagging** strategy
- **Detailed outputs** for integration
- **CORS support** for web applications

## Usage

### Basic Example

```hcl
module "storage_account" {
  source = "./modules/azure-storage-account"

  storage_account_name = "mystorageacct001"
  resource_group_name  = "rg-storage-prod"
  location            = "West Europe"

  tags = {
    Environment = "production"
    Owner       = "platform-team"
  }
}
```

### Advanced Example with Security Features

```hcl
module "secure_storage" {
  source = "./modules/azure-storage-account"

  storage_account_name = "securestorage001"
  resource_group_name  = "rg-secure-prod"
  location            = "West Europe"

  # Storage configuration
  account_tier     = "Standard"
  replication_type = "GRS"
  account_kind     = "StorageV2"

  # Security settings
  min_tls_version              = "TLS1_2"
  allow_public_access          = false
  public_network_access_enabled = false
  shared_access_key_enabled    = false

  # Network restrictions
  network_rules_enabled        = true
  network_rules_default_action = "Deny"
  allowed_ip_ranges           = ["203.0.113.0/24"]
  allowed_subnet_ids          = ["/subscriptions/.../subnets/secure-subnet"]

  # Blob protection
  blob_versioning_enabled         = true
  change_feed_enabled            = true
  blob_delete_retention_days     = 30
  container_delete_retention_days = 30

  # Private endpoint
  enable_private_endpoint    = true
  private_endpoint_subnet_id = "/subscriptions/.../subnets/pe-subnet"
  private_dns_zone_id       = "/subscriptions/.../privateDnsZones/privatelink.blob.core.windows.net"

  # Containers
  containers = {
    "documents" = {
      access_type = "private"
      metadata = {
        purpose = "document-storage"
      }
    }
    "backups" = {
      access_type = "private"
      metadata = {
        retention = "7-years"
      }
    }
  }

  # Identity
  identity_type = "SystemAssigned"

  tags = {
    Environment = "production"
    Compliance  = "required"
    Owner       = "security-team"
  }
}
```

### CORS Configuration Example

```hcl
module "web_storage" {
  source = "./modules/azure-storage-account"

  storage_account_name = "webstorage001"
  resource_group_name  = "rg-web-prod"
  location            = "West Europe"

  cors_rules = [
    {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "POST", "PUT"]
      allowed_origins    = ["https://mywebapp.com", "https://admin.mywebapp.com"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  ]

  containers = {
    "web-assets" = {
      access_type = "blob"
      metadata = {
        purpose = "static-website"
      }
    }
  }
}
```

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| azurerm   | >= 3.0  |

## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | >= 3.0  |

## Inputs

### Required Variables

| Name                 | Description                                                       | Type     |
| -------------------- | ----------------------------------------------------------------- | -------- |
| storage_account_name | Name of the storage account (3-24 chars, lowercase, numbers only) | `string` |
| resource_group_name  | Resource group name                                               | `string` |

### Optional Variables

| Name                       | Description                | Type     | Default         |
| -------------------------- | -------------------------- | -------- | --------------- |
| location                   | Azure region               | `string` | `"West Europe"` |
| account_tier               | Storage performance tier   | `string` | `"Standard"`    |
| replication_type           | Replication strategy       | `string` | `"LRS"`         |
| account_kind               | Storage account type       | `string` | `"StorageV2"`   |
| min_tls_version            | Minimum TLS version        | `string` | `"TLS1_2"`      |
| allow_public_access        | Allow public blob access   | `bool`   | `false`         |
| blob_versioning_enabled    | Enable blob versioning     | `bool`   | `true`          |
| blob_delete_retention_days | Blob soft delete retention | `number` | `7`             |
| enable_private_endpoint    | Enable private endpoint    | `bool`   | `false`         |

_See [variables.tf](./variables.tf) for complete list of variables and validation rules._

## Outputs

### Primary Outputs

| Name                      | Description                           |
| ------------------------- | ------------------------------------- |
| storage_account_name      | Storage account name                  |
| primary_blob_endpoint     | Primary blob endpoint URL             |
| primary_connection_string | Primary connection string (sensitive) |

_See [outputs.tf](./outputs.tf) for complete list of outputs._

## Security Considerations

### Default Security Posture

- **HTTPS-only** traffic enforced
- **TLS 1.2 minimum** required
- **Public access disabled** by default
- **Soft delete enabled** for data protection
- **Lifecycle protection** prevents accidental deletion

### Network Security

- Configure **network rules** to restrict access
- Use **private endpoints** for secure connectivity
- Implement **subnet restrictions** for enhanced security
- Consider **service endpoints** for Azure services

### Authentication Options

- **Managed identities** for service-to-service auth
- **Shared access keys** (can be disabled for enhanced security)
- **Azure AD integration** through RBAC
- **SAS tokens** with granular permissions

## Examples

See the [examples](./examples/) directory for:

- Basic storage account

## Contributing

When contributing to this module:

1. Follow Terraform best practices
2. Add appropriate input validation
3. Update documentation
4. Include example usage
5. Test with multiple scenarios
