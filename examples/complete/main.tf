module "dynamodb_table" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=master"
  namespace                    = "eg"
  stage                        = "dev"
  name                         = "cluster"
  hash_key                     = "HashKey"
  range_key                    = "RangeKey"
  autoscale_write_target       = 50
  autoscale_read_target        = 50
  autoscale_min_read_capacity  = 5
  autoscale_max_read_capacity  = 20
  autoscale_min_write_capacity = 5
  autoscale_max_write_capacity = 20
  enable_autoscaler            = "true"

  dynamodb_attributes = [
    {
      name = "DailyAverage"
      type = "N"
    },
    {
      name = "HighWater"
      type = "N"
    },
    {
      name = "Timestamp"
      type = "S"
    },
  ]

  local_secondary_index_map = [
    {
      name               = "TimestampSortIndex"
      range_key          = "Timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    },
    {
      name               = "HighWaterIndex"
      range_key          = "Timestamp"
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    },
  ]

  global_secondary_index_map = [
    {
      name               = "DailyAverageIndex"
      hash_key           = "DailyAverage"
      range_key          = "HighWater"
      write_capacity     = 5
      read_capacity      = 5
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    },
    {
      name            = "HighWaterIndex"
      hash_key        = "HighWater"
      write_capacity  = 5
      read_capacity   = 5
      projection_type = "KEYS_ONLY"
    },
  ]
}
