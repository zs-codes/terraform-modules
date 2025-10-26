# Basic Azure Storage Account Example

This example demonstrates the basic usage of the Azure Storage Account module with minimal configuration.

## Usage

1. Update the variables in `terraform.tfvars`
2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Resources Created

- Azure Storage Account (Standard LRS)
- Basic blob container
- Default security settings

## Outputs

The example outputs the storage account connection details and endpoints for immediate use.
