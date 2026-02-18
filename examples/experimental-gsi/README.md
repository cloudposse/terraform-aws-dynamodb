# Experimental Global Secondary Index Example

This example demonstrates how to use the experimental `aws_dynamodb_global_secondary_index` resource.

## Important Notes

⚠️ **EXPERIMENTAL FEATURE**: This resource is experimental and requires special configuration.

### Prerequisites

You **MUST** set the environment variable before running any Terraform commands:

```bash
export TF_AWS_EXPERIMENT_dynamodb_global_secondary_index=1
```

Without this environment variable, Terraform validation will fail.

### Usage

```bash
# Set the experimental feature flag
export TF_AWS_EXPERIMENT_dynamodb_global_secondary_index=1

# Initialize and plan
terraform init
terraform plan -var-file=fixtures.us-east-2.tfvars

# Apply (for testing only - this will create real AWS resources)
terraform apply -var-file=fixtures.us-east-2.tfvars

# Cleanup
terraform destroy -var-file=fixtures.us-east-2.tfvars
```

### What This Example Demonstrates

- Using `global_secondary_index_resource_enabled = true` to enable the experimental standalone GSI resource
- Creating a Global Secondary Index using the standalone resource instead of inline blocks
- The GSI configuration uses the same `global_secondary_index_map` variable as the traditional approach

### Warnings

- Do NOT use this on existing production tables
- Do NOT toggle `global_secondary_index_resource_enabled` on an existing table - it will recreate the indexes
- This experimental feature may change or be removed in future AWS provider versions
- Not covered by any SLA or support agreement
