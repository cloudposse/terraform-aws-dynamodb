provider "aws" {
  region = var.region
}

module "dynamodb_table_with_experimental_gsi" {
  source = "../../"

  namespace                               = "eg"
  stage                                   = "test"
  name                                    = "gsi-test"
  hash_key                                = "HashKey"
  range_key                               = "RangeKey"
  enable_autoscaler                       = true
  global_secondary_index_resource_enabled = true

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
    }
  ]

  # When using the experimental standalone GSI resource, use the same global_secondary_index_map variable
  global_secondary_index_map = [
    {
      name               = "DailyAverageIndex"
      hash_key           = "DailyAverage"
      range_key          = "HighWater"
      write_capacity     = 5
      read_capacity      = 5
      projection_type    = "INCLUDE"
      non_key_attributes = ["HashKey", "RangeKey"]
    }
  ]
}
