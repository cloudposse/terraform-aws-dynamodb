locals {
  enabled = module.this.enabled

  attributes = concat(
    [
      {
        name = var.range_key
        type = var.range_key_type
      },
      {
        name = var.hash_key
        type = var.hash_key_type
      }
    ],
    var.dynamodb_attributes
  )

  # Remove the first map from the list if no `range_key` is provided
  from_index = length(var.range_key) > 0 ? 0 : 1

  attributes_final = slice(local.attributes, local.from_index, length(local.attributes))
}

resource "null_resource" "global_secondary_index_names" {
  count = (local.enabled ? 1 : 0) * length(var.global_secondary_index_map)

  # Convert the multi-item `global_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = {
    "name" = var.global_secondary_index_map[count.index]["name"]
  }
}

resource "null_resource" "local_secondary_index_names" {
  count = (local.enabled ? 1 : 0) * length(var.local_secondary_index_map)

  # Convert the multi-item `local_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = {
    "name" = var.local_secondary_index_map[count.index]["name"]
  }
}

resource "aws_dynamodb_table" "default" {
  count            = local.enabled ? 1 : 0
  name             = module.this.id
  billing_mode     = var.billing_mode
  read_capacity    = var.autoscale_min_read_capacity
  write_capacity   = var.autoscale_min_write_capacity
  hash_key         = var.hash_key
  range_key        = var.range_key
  stream_enabled   = length(var.replicas) > 0 ? true : var.enable_streams
  stream_view_type = length(var.replicas) > 0 || var.enable_streams ? var.stream_view_type : ""


  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  lifecycle {
    ignore_changes = [
      read_capacity,
      write_capacity
    ]
  }

  dynamic "attribute" {
    for_each = local.attributes_final
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index_map
    content {
      hash_key           = global_secondary_index.value.hash_key
      name               = global_secondary_index.value.name
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index_map
    content {
      name               = local_secondary_index.value.name
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
      projection_type    = local_secondary_index.value.projection_type
      range_key          = local_secondary_index.value.range_key
    }
  }

  dynamic "replica" {
    for_each = var.replicas
    content {
      region_name = replica.value
    }
  }

  dynamic "ttl" {
    for_each = var.ttl_enabled ? [1] : []
    content {
      attribute_name = var.ttl_attribute
      enabled        = var.ttl_enabled
    }
  }

  tags = module.this.tags
}

module "dynamodb_autoscaler" {
  source  = "cloudposse/dynamodb-autoscaler/aws"
  version = "0.13.1"
  enabled = local.enabled && var.enable_autoscaler && var.billing_mode == "PROVISIONED"

  attributes                   = concat(module.this.attributes, var.autoscaler_attributes)
  tags                         = merge(module.this.tags, var.autoscaler_tags)
  dynamodb_table_name          = join("", aws_dynamodb_table.default.*.id)
  dynamodb_table_arn           = join("", aws_dynamodb_table.default.*.arn)
  dynamodb_indexes             = null_resource.global_secondary_index_names.*.triggers.name
  autoscale_write_target       = var.autoscale_write_target
  autoscale_read_target        = var.autoscale_read_target
  autoscale_min_read_capacity  = var.autoscale_min_read_capacity
  autoscale_max_read_capacity  = var.autoscale_max_read_capacity
  autoscale_min_write_capacity = var.autoscale_min_write_capacity
  autoscale_max_write_capacity = var.autoscale_max_write_capacity

  context = module.this.context
}
