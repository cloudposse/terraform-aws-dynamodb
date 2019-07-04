## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `policy` or `role`) | list(string) | `<list>` | no |
| autoscale_max_read_capacity | DynamoDB autoscaling max read capacity | number | `20` | no |
| autoscale_max_write_capacity | DynamoDB autoscaling max write capacity | number | `20` | no |
| autoscale_min_read_capacity | DynamoDB autoscaling min read capacity | number | `5` | no |
| autoscale_min_write_capacity | DynamoDB autoscaling min write capacity | number | `5` | no |
| autoscale_read_target | The target value (in %) for DynamoDB read autoscaling | number | `50` | no |
| autoscale_write_target | The target value (in %) for DynamoDB write autoscaling | number | `50` | no |
| billing_mode | DynamoDB Billing mode. Can be PROVISIONED or PAY_PER_REQUEST | string | `PROVISIONED` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | string | `-` | no |
| dynamodb_attributes | Additional DynamoDB attributes in the form of a list of mapped values | object | `<list>` | no |
| enable_autoscaler | Flag to enable/disable DynamoDB autoscaling | string | `true` | no |
| enable_encryption | Enable DynamoDB server-side encryption | bool | `true` | no |
| enable_point_in_time_recovery | Enable DynamoDB point in time recovery | bool | `true` | no |
| enable_streams | Enable DynamoDB streams | bool | `false` | no |
| enabled | Set to false to prevent the module from creating any resources | bool | `true` | no |
| global_secondary_index_map | Additional global secondary indexes in the form of a list of mapped values | object | `<list>` | no |
| hash_key | DynamoDB table Hash Key | string | - | yes |
| hash_key_type | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `S` | no |
| local_secondary_index_map | Additional local secondary indexes in the form of a list of mapped values | object | `<list>` | no |
| name | Name  (e.g. `app` or `cluster`) | string | - | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | string | `` | no |
| range_key | DynamoDB table Range Key | string | `` | no |
| range_key_type | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | string | `S` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`, `infra`) | string | `` | no |
| stream_view_type | When an item in the table is modified, what information is written to the stream | string | `` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | map(string) | `<map>` | no |
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

