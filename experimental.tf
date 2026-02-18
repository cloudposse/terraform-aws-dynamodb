# ==============================================================================
# EXPERIMENTAL FEATURES
# ==============================================================================
#
# This file contains experimental AWS provider features that are NOT stable.
#
# IMPORTANT: ALL users of this module (even those NOT using experimental features)
# must set this environment variable for Terraform validation to pass:
#
#   export TF_AWS_EXPERIMENT_dynamodb_global_secondary_index=1
#
# This is required because:
# 1. Terraform loads all .tf files in a directory
# 2. AWS provider validates experimental resources even when for_each = {} (no instances)
# 3. This is a known AWS provider limitation, not a bug in this module
#
# For more information:
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_global_secondary_index
# ==============================================================================

locals {
  # For experimental GSI resource: convert list to map for for_each
  gsi_map_for_resource = local.enabled && var.global_secondary_index_resource_enabled ? {
    for idx in var.global_secondary_index_map : idx.name => idx
  } : {}
}

# Experimental aws_dynamodb_global_secondary_index resource
# This resource is only created when global_secondary_index_resource_enabled is set to true
# It uses the same global_secondary_index_map variable but creates standalone resources instead of inline blocks
# WARNING: Do NOT toggle this flag on an existing table as it will cause Terraform to recreate the indexes
# See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_global_secondary_index
resource "aws_dynamodb_global_secondary_index" "default" {
  for_each = local.gsi_map_for_resource

  table_name = join("", aws_dynamodb_table.default[*].name)
  index_name = each.value.name

  # Key schema for hash key (must be static, not dynamic, for AWS provider validation)
  key_schema {
    attribute_name = each.value.hash_key
    # Find attribute type from the attributes list, with validation to ensure it exists
    attribute_type = coalesce(
      try([for attr in local.attributes_final : attr.type if attr.name == each.value.hash_key][0], null),
      "S" # Default to String if not found (for backward compatibility)
    )
    key_type = "HASH"
  }

  # Key schema for range key (if provided)
  dynamic "key_schema" {
    for_each = (
      lookup(each.value, "range_key", null) != null &&
      lookup(each.value, "range_key", "") != ""
    ) ? [each.value.range_key] : []

    content {
      attribute_name = key_schema.value
      # Find attribute type from the attributes list, with validation to ensure it exists
      attribute_type = coalesce(
        try([for attr in local.attributes_final : attr.type if attr.name == key_schema.value][0], null),
        "S" # Default to String if not found (for backward compatibility)
      )
      key_type = "RANGE"
    }
  }

  # Projection configuration
  projection {
    projection_type    = each.value.projection_type
    non_key_attributes = lookup(each.value, "non_key_attributes", null)
  }

  # Provisioned throughput (for PROVISIONED billing mode)
  dynamic "provisioned_throughput" {
    for_each = var.billing_mode == "PROVISIONED" && (lookup(each.value, "read_capacity", null) != null || lookup(each.value, "write_capacity", null) != null) ? [1] : []
    content {
      read_capacity_units  = lookup(each.value, "read_capacity", null)
      write_capacity_units = lookup(each.value, "write_capacity", null)
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}
