module "dynamodb_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
}

locals {
  attributes = [
    {
      name = "${var.range_key}"
      type = "${var.range_key_type}"
    },
    {
      name = "${var.hash_key}"
      type = "${var.hash_key_type}"
    },
    "${var.dynamodb_attributes}",
  ]

  # Use the `slice` pattern (instead of `conditional`) to remove the first map from the list if no `range_key` is provided
  # Terraform does not support conditionals with `lists` and `maps`: aws_dynamodb_table.default: conditional operator cannot be used with list values
  from_index = "${length(var.range_key) > 0 ? 0 : 1}"

  attributes_final = "${slice(local.attributes, local.from_index, length(local.attributes))}"
}

resource "null_resource" "global_secondary_index_names" {
  count = "${(var.enabled ? 1 : 0 ) * length(var.global_secondary_index_map)}"

  # Convert the multi-item `global_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = "${map("name", lookup(var.global_secondary_index_map[count.index], "name"))}"
}

resource "null_resource" "local_secondary_index_names" {
  count = "${(var.enabled ? 1 : 0 ) * length(var.local_secondary_index_map)}"

  # Convert the multi-item `local_secondary_index_map` into a simple `map` with just one item `name` since `triggers` does not support `lists` in `maps` (which are used in `non_key_attributes`)
  # See `examples/complete`
  # https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html#non_key_attributes-1
  triggers = "${map("name", lookup(var.local_secondary_index_map[count.index], "name"))}"
}

resource "aws_dynamodb_table" "default" {
  count            = "${var.enabled ? 1 : 0 }"
  name             = "${module.dynamodb_label.id}"
  read_capacity    = "${var.autoscale_min_read_capacity}"
  write_capacity   = "${var.autoscale_min_write_capacity}"
  hash_key         = "${var.hash_key}"
  range_key        = "${var.range_key}"
  stream_enabled   = "${var.enable_streams}"
  stream_view_type = "${var.enable_streams == "true" ? var.stream_view_type : ""}"

  server_side_encryption {
    enabled = "${var.enable_encryption}"
  }

  point_in_time_recovery {
    enabled = "${var.enable_point_in_time_recovery}"
  }

  lifecycle {
    ignore_changes = ["read_capacity", "write_capacity"]
  }

  attribute              = ["${local.attributes_final}"]
  global_secondary_index = ["${var.global_secondary_index_map}"]
  local_secondary_index  = ["${var.local_secondary_index_map}"]

  ttl {
    attribute_name = "${var.ttl_attribute}"
    enabled        = true
  }

  tags = "${module.dynamodb_label.tags}"
}

module "dynamodb_autoscaler" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-dynamodb-autoscaler.git?ref=tags/0.2.5"
  enabled                      = "${var.enabled && var.enable_autoscaler}"
  namespace                    = "${var.namespace}"
  stage                        = "${var.stage}"
  name                         = "${var.name}"
  delimiter                    = "${var.delimiter}"
  attributes                   = "${var.attributes}"
  dynamodb_table_name          = "${element(concat(aws_dynamodb_table.default.*.id, list("")), 0)}"
  dynamodb_table_arn           = "${element(concat(aws_dynamodb_table.default.*.arn, list("")), 0)}"
  dynamodb_indexes             = ["${null_resource.global_secondary_index_names.*.triggers.name}"]
  autoscale_write_target       = "${var.autoscale_write_target}"
  autoscale_read_target        = "${var.autoscale_read_target}"
  autoscale_min_read_capacity  = "${var.autoscale_min_read_capacity}"
  autoscale_max_read_capacity  = "${var.autoscale_max_read_capacity}"
  autoscale_min_write_capacity = "${var.autoscale_min_write_capacity}"
  autoscale_max_write_capacity = "${var.autoscale_max_write_capacity}"
}
