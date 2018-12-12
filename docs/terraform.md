## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list | `<list>` | no |
| autoscale_max_read_capacity | DynamoDB autoscaling max read capacity | string | `20` | no |
| autoscale_max_write_capacity | DynamoDB autoscaling max write capacity | string | `20` | no |
| autoscale_min_read_capacity | DynamoDB autoscaling min read capacity | string | `5` | no |
| autoscale_min_write_capacity | DynamoDB autoscaling min write capacity | string | `5` | no |
| autoscale_read_target | The target value (in %) for DynamoDB read autoscaling | string | `50` | no |
| autoscale_write_target | The target value (in %) for DynamoDB write autoscaling | string | `50` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | string | `-` | no |
| dynamodb_attributes | Additional DynamoDB attributes in the form of a list of mapped values | list | `<list>` | no |
| enable_autoscaler | Flag to enable/disable DynamoDB autoscaling | string | `true` | no |
| enable_encryption | Enable DynamoDB server-side encryption | string | `true` | no |
| enable_point_in_time_recovery | Enable DynamoDB point in time recovery | string | `true` | no |
| enable_streams | Enable DynamoDB streams | string | `false` | no |
| global_secondary_index_map | Additional global secondary indexes in the form of a list of mapped values | list | `<list>` | no |
| hash_key | DynamoDB table Hash Key | string | - | yes |
| hash_key_type | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `S` | no |
| local_secondary_index_map | Additional local secondary indexes in the form of a list of mapped values | list | `<list>` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | - | yes |
| range_key | DynamoDB table Range Key | string | `` | no |
| range_key_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `S` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`, `infra`) | string | - | yes |
| stream_view_type | When an item in the table is modified, what information is written to the stream | string | `` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| ttl_attribute | DynamoDB table TTL attribute | string | `Expires` | no |

## Outputs

| Name | Description |
|------|-------------|
| global_secondary_index_names | DynamoDB secondary index names |
| local_secondary_index_names | DynamoDB local index names |
| table_arn | DynamoDB table ARN |
| table_id | DynamoDB table ID |
| table_name | DynamoDB table name |
| table_stream_arn | DynamoDB table stream ARN |
| table_stream_label | DynamoDB table stream label |

