

<!-- markdownlint-disable -->
# terraform-aws-dynamodb <a href="https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content="><img align="right" src="https://cloudposse.com/logo-300x69.svg" width="150" /></a>
<a href="https://github.com/cloudposse/terraform-aws-dynamodb/releases/latest"><img src="https://img.shields.io/github/release/cloudposse/terraform-aws-dynamodb.svg?style=for-the-badge" alt="Latest Release"/></a><a href="https://github.com/cloudposse/terraform-aws-dynamodb/commits"><img src="https://img.shields.io/github/last-commit/cloudposse/terraform-aws-dynamodb.svg?style=for-the-badge" alt="Last Updated"/></a><a href="https://slack.cloudposse.com"><img src="https://slack.cloudposse.com/for-the-badge.svg" alt="Slack Community"/></a>
<!-- markdownlint-restore -->

<!--




  ** DO NOT EDIT THIS FILE
  **
  ** This file was automatically generated by the `cloudposse/build-harness`.
  ** 1) Make all changes to `README.yaml`
  ** 2) Run `make init` (you only need to do this once)
  ** 3) Run`make readme` to rebuild this file.
  **
  ** (We maintain HUNDREDS of open source projects. This is how we maintain our sanity.)
  **





-->

Terraform module to provision a DynamoDB table with autoscaling.

Autoscaler scales up/down the provisioned OPS for the DynamoDB table based on the load.

## Requirements

This module requires [AWS Provider](https://github.com/terraform-providers/terraform-provider-aws) `>= 4.22.0`


> [!TIP]
> #### 👽 Use Atmos with Terraform
> Cloud Posse uses [`atmos`](https://atmos.tools) to easily orchestrate multiple environments using Terraform. <br/>
> Works with [Github Actions](https://atmos.tools/integrations/github-actions/), [Atlantis](https://atmos.tools/integrations/atlantis), or [Spacelift](https://atmos.tools/integrations/spacelift).
>
> <details>
> <summary><strong>Watch demo of using Atmos with Terraform</strong></summary>
> <img src="https://github.com/cloudposse/atmos/blob/master/docs/demo.gif?raw=true"/><br/>
> <i>Example of running <a href="https://atmos.tools"><code>atmos</code></a> to manage infrastructure from our <a href="https://atmos.tools/quick-start/">Quick Start</a> tutorial.</i>
> </detalis>





## Usage


For a complete example, see [examples/complete](examples/complete).

For automated tests of the complete example using [bats](https://github.com/bats-core/bats-core) and [Terratest](https://github.com/gruntwork-io/terratest) (which tests and deploys the example on AWS), see [test](test).

```hcl
module "dynamodb_table" {
  source = "cloudposse/dynamodb/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
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
  enable_autoscaler            = true
}
```

## Advanced Usage

With additional attributes, global secondary indexes and `non_key_attributes` (see [examples/complete](examples/complete)).

```hcl
module "dynamodb_table" {
  source = "cloudposse/dynamodb/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
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
  enable_autoscaler            = true

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
    }
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
    }
  ]

  replicas = ["us-east-1"]
}
```

__NOTE:__ Variables "global_secondary_index_map" and "local_secondary_index_map" have a predefined schema, but in some cases not all fields are required or needed.

For example:
 * `non_key_attributes` can't be specified for Global Secondary Indexes (GSIs) when `projection_type` is `ALL`
 * `read_capacity` and `write_capacity` are not required for GSIs

In these cases, set the fields to `null` and Terraform will treat them as if they were not provided at all, but will not complain about missing values:

```hcl
  global_secondary_index_map = [
    {
      write_capacity     = null
      read_capacity      = null
      projection_type    = "ALL"
      non_key_attributes = null
    }
  ]
```

See [Terraform types and values](https://www.terraform.io/docs/configuration/expressions.html#types-and-values) for more details.

> [!IMPORTANT]
> In Cloud Posse's examples, we avoid pinning modules to specific versions to prevent discrepancies between the documentation
> and the latest released versions. However, for your own projects, we strongly advise pinning each module to the exact version
> you're using. This practice ensures the stability of your infrastructure. Additionally, we recommend implementing a systematic
> approach for updating versions to avoid unexpected changes.








<!-- markdownlint-disable -->
## Makefile Targets
```text
Available targets:

  help                                Help screen
  help/all                            Display help for all targets
  help/short                          This help short screen
  lint                                Lint terraform code

```
<!-- markdownlint-restore -->
<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.59 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.59 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dynamodb_autoscaler"></a> [dynamodb\_autoscaler](#module\_dynamodb\_autoscaler) | cloudposse/dynamodb-autoscaler/aws | 0.14.0 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [null_resource.global_secondary_index_names](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.local_secondary_index_names](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_autoscale_max_read_capacity"></a> [autoscale\_max\_read\_capacity](#input\_autoscale\_max\_read\_capacity) | DynamoDB autoscaling max read capacity | `number` | `20` | no |
| <a name="input_autoscale_max_write_capacity"></a> [autoscale\_max\_write\_capacity](#input\_autoscale\_max\_write\_capacity) | DynamoDB autoscaling max write capacity | `number` | `20` | no |
| <a name="input_autoscale_min_read_capacity"></a> [autoscale\_min\_read\_capacity](#input\_autoscale\_min\_read\_capacity) | DynamoDB autoscaling min read capacity | `number` | `5` | no |
| <a name="input_autoscale_min_write_capacity"></a> [autoscale\_min\_write\_capacity](#input\_autoscale\_min\_write\_capacity) | DynamoDB autoscaling min write capacity | `number` | `5` | no |
| <a name="input_autoscale_read_target"></a> [autoscale\_read\_target](#input\_autoscale\_read\_target) | The target value (in %) for DynamoDB read autoscaling | `number` | `50` | no |
| <a name="input_autoscale_write_target"></a> [autoscale\_write\_target](#input\_autoscale\_write\_target) | The target value (in %) for DynamoDB write autoscaling | `number` | `50` | no |
| <a name="input_autoscaler_attributes"></a> [autoscaler\_attributes](#input\_autoscaler\_attributes) | Additional attributes for the autoscaler module | `list(string)` | `[]` | no |
| <a name="input_autoscaler_tags"></a> [autoscaler\_tags](#input\_autoscaler\_tags) | Additional resource tags for the autoscaler module | `map(string)` | `{}` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | DynamoDB Billing mode. Can be PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PROVISIONED"` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enable/disable DynamoDB table deletion protection | `bool` | `false` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_dynamodb_attributes"></a> [dynamodb\_attributes](#input\_dynamodb\_attributes) | Additional DynamoDB attributes in the form of a list of mapped values | <pre>list(object({<br>    name = string<br>    type = string<br>  }))</pre> | `[]` | no |
| <a name="input_enable_autoscaler"></a> [enable\_autoscaler](#input\_enable\_autoscaler) | Flag to enable/disable DynamoDB autoscaling | `bool` | `false` | no |
| <a name="input_enable_encryption"></a> [enable\_encryption](#input\_enable\_encryption) | Enable DynamoDB server-side encryption | `bool` | `true` | no |
| <a name="input_enable_point_in_time_recovery"></a> [enable\_point\_in\_time\_recovery](#input\_enable\_point\_in\_time\_recovery) | Enable DynamoDB point in time recovery | `bool` | `true` | no |
| <a name="input_enable_streams"></a> [enable\_streams](#input\_enable\_streams) | Enable DynamoDB streams | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_global_secondary_index_map"></a> [global\_secondary\_index\_map](#input\_global\_secondary\_index\_map) | Additional global secondary indexes in the form of a list of mapped values | <pre>list(object({<br>    hash_key           = string<br>    name               = string<br>    non_key_attributes = list(string)<br>    projection_type    = string<br>    range_key          = string<br>    read_capacity      = number<br>    write_capacity     = number<br>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | DynamoDB table Hash Key | `string` | n/a | yes |
| <a name="input_hash_key_type"></a> [hash\_key\_type](#input\_hash\_key\_type) | Hash Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | `string` | `"S"` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_table"></a> [import\_table](#input\_import\_table) | Import Amazon S3 data into a new table. | <pre>object({<br>    # Valid values are GZIP, ZSTD and NONE<br>    input_compression_type = optional(string, null)<br>    # Valid values are CSV, DYNAMODB_JSON, and ION.<br>    input_format = string<br>    input_format_options = optional(object({<br>      csv = object({<br>        delimiter   = string<br>        header_list = list(string)<br>      })<br>    }), null)<br>    s3_bucket_source = object({<br>      bucket       = string<br>      bucket_owner = optional(string)<br>      key_prefix   = optional(string)<br>    })<br>  })</pre> | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_local_secondary_index_map"></a> [local\_secondary\_index\_map](#input\_local\_secondary\_index\_map) | Additional local secondary indexes in the form of a list of mapped values | <pre>list(object({<br>    name               = string<br>    non_key_attributes = list(string)<br>    projection_type    = string<br>    range_key          = string<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | DynamoDB table Range Key | `string` | `""` | no |
| <a name="input_range_key_type"></a> [range\_key\_type](#input\_range\_key\_type) | Range Key type, which must be a scalar type: `S`, `N`, or `B` for (S)tring, (N)umber or (B)inary data | `string` | `"S"` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | List of regions to create replica | `list(string)` | `[]` | no |
| <a name="input_server_side_encryption_kms_key_arn"></a> [server\_side\_encryption\_kms\_key\_arn](#input\_server\_side\_encryption\_kms\_key\_arn) | The ARN of the CMK that should be used for the AWS KMS encryption. This attribute should only be specified if the key is different from the default DynamoDB CMK, alias/aws/dynamodb. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | When an item in the table is modified, what information is written to the stream | `string` | `""` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | DynamoDB storage class of the table. Can be STANDARD or STANDARD\_INFREQUENT\_ACCESS | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tags_enabled"></a> [tags\_enabled](#input\_tags\_enabled) | Set to `false` to disable tagging. This can be helpful if you're managing tables on dynamodb-local with terraform as it doesn't support tagging. | `bool` | `true` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | DynamoDB table TTL attribute | `string` | `"Expires"` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Set to false to disable DynamoDB table TTL | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_global_secondary_index_names"></a> [global\_secondary\_index\_names](#output\_global\_secondary\_index\_names) | DynamoDB secondary index names |
| <a name="output_local_secondary_index_names"></a> [local\_secondary\_index\_names](#output\_local\_secondary\_index\_names) | DynamoDB local index names |
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | DynamoDB table ARN |
| <a name="output_table_id"></a> [table\_id](#output\_table\_id) | DynamoDB table ID |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | DynamoDB table name |
| <a name="output_table_stream_arn"></a> [table\_stream\_arn](#output\_table\_stream\_arn) | DynamoDB table stream ARN |
| <a name="output_table_stream_label"></a> [table\_stream\_label](#output\_table\_stream\_label) | DynamoDB table stream label |
<!-- markdownlint-restore -->


## Related Projects

Check out these related projects.

- [terraform-aws-dynamodb-autoscaler](https://github.com/cloudposse/terraform-aws-dynamodb-autoscaler) - Terraform module to provision DynamoDB autoscaler
- [terraform-aws-tfstate-backend](https://github.com/cloudposse/terraform-aws-tfstate-backend) - Provision an S3 bucket to store terraform.tfstate file and a DynamoDB table to lock the state file to prevent concurrent modifications and state corruption
- [terraform-aws-elasticache-redis](https://github.com/cloudposse/terraform-aws-elasticache-redis) - Terraform module to provision an ElastiCache Redis Cluster
- [terraform-aws-elasticache-memcached](https://github.com/cloudposse/terraform-aws-elasticache-memcached) - Terraform Module for ElastiCache Memcached Cluster
- [terraform-aws-elasticache-cloudwatch-sns-alarms](https://github.com/cloudposse/terraform-aws-elasticache-cloudwatch-sns-alarms) - Terraform module that configures CloudWatch SNS alerts for ElastiCache
- [terraform-aws-rds-cluster](https://github.com/cloudposse/terraform-aws-rds-cluster) - Terraform module to provision an RDS Aurora cluster for MySQL or Postgres
- [terraform-aws-rds](https://github.com/cloudposse/terraform-aws-rds) - Terraform module to provision AWS RDS instances


> [!TIP]
> #### Use Terraform Reference Architectures for AWS
>
> Use Cloud Posse's ready-to-go [terraform architecture blueprints](https://cloudposse.com/reference-architecture/) for AWS to get up and running quickly.
>
> ✅ We build it with you.<br/>
> ✅ You own everything.<br/>
> ✅ Your team wins.<br/>
>
> <a href="https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=commercial_support"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
> <details><summary>📚 <strong>Learn More</strong></summary>
>
> <br/>
>
> Cloud Posse is the leading [**DevOps Accelerator**](https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=commercial_support) for funded startups and enterprises.
>
> *Your team can operate like a pro today.*
>
> Ensure that your team succeeds by using Cloud Posse's proven process and turnkey blueprints. Plus, we stick around until you succeed.
> #### Day-0:  Your Foundation for Success
> - **Reference Architecture.** You'll get everything you need from the ground up built using 100% infrastructure as code.
> - **Deployment Strategy.** Adopt a proven deployment strategy with GitHub Actions, enabling automated, repeatable, and reliable software releases.
> - **Site Reliability Engineering.** Gain total visibility into your applications and services with Datadog, ensuring high availability and performance.
> - **Security Baseline.** Establish a secure environment from the start, with built-in governance, accountability, and comprehensive audit logs, safeguarding your operations.
> - **GitOps.** Empower your team to manage infrastructure changes confidently and efficiently through Pull Requests, leveraging the full power of GitHub Actions.
>
> <a href="https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=commercial_support"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
>
> #### Day-2: Your Operational Mastery
> - **Training.** Equip your team with the knowledge and skills to confidently manage the infrastructure, ensuring long-term success and self-sufficiency.
> - **Support.** Benefit from a seamless communication over Slack with our experts, ensuring you have the support you need, whenever you need it.
> - **Troubleshooting.** Access expert assistance to quickly resolve any operational challenges, minimizing downtime and maintaining business continuity.
> - **Code Reviews.** Enhance your team’s code quality with our expert feedback, fostering continuous improvement and collaboration.
> - **Bug Fixes.** Rely on our team to troubleshoot and resolve any issues, ensuring your systems run smoothly.
> - **Migration Assistance.** Accelerate your migration process with our dedicated support, minimizing disruption and speeding up time-to-value.
> - **Customer Workshops.** Engage with our team in weekly workshops, gaining insights and strategies to continuously improve and innovate.
>
> <a href="https://cpco.io/commercial-support?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=commercial_support"><img alt="Request Quote" src="https://img.shields.io/badge/request%20quote-success.svg?style=for-the-badge"/></a>
> </details>

## ✨ Contributing

This project is under active development, and we encourage contributions from our community.



Many thanks to our outstanding contributors:

<a href="https://github.com/cloudposse/terraform-aws-dynamodb/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudposse/terraform-aws-dynamodb&max=24" />
</a>

For 🐛 bug reports & feature requests, please use the [issue tracker](https://github.com/cloudposse/terraform-aws-dynamodb/issues).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.
 1. Review our [Code of Conduct](https://github.com/cloudposse/terraform-aws-dynamodb/?tab=coc-ov-file#code-of-conduct) and [Contributor Guidelines](https://github.com/cloudposse/.github/blob/main/CONTRIBUTING.md).
 2. **Fork** the repo on GitHub
 3. **Clone** the project to your own machine
 4. **Commit** changes to your own branch
 5. **Push** your work back up to your fork
 6. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

### 🌎 Slack Community

Join our [Open Source Community](https://cpco.io/slack?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=slack) on Slack. It's **FREE** for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build totally *sweet* infrastructure.

### 📰 Newsletter

Sign up for [our newsletter](https://cpco.io/newsletter?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=newsletter) and join 3,000+ DevOps engineers, CTOs, and founders who get insider access to the latest DevOps trends, so you can always stay in the know.
Dropped straight into your Inbox every week — and usually a 5-minute read.

### 📆 Office Hours <a href="https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=office_hours"><img src="https://img.cloudposse.com/fit-in/200x200/https://cloudposse.com/wp-content/uploads/2019/08/Powered-by-Zoom.png" align="right" /></a>

[Join us every Wednesday via Zoom](https://cloudposse.com/office-hours?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=office_hours) for your weekly dose of insider DevOps trends, AWS news and Terraform insights, all sourced from our SweetOps community, plus a _live Q&A_ that you can’t find anywhere else.
It's **FREE** for everyone!
## License

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg?style=for-the-badge" alt="License"></a>

<details>
<summary>Preamble to the Apache License, Version 2.0</summary>
<br/>
<br/>

Complete license is available in the [`LICENSE`](LICENSE) file.

```text
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

  https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
```
</details>

## Trademarks

All other trademarks referenced herein are the property of their respective owners.


---
Copyright © 2017-2024 [Cloud Posse, LLC](https://cpco.io/copyright)


<a href="https://cloudposse.com/readme/footer/link?utm_source=github&utm_medium=readme&utm_campaign=cloudposse/terraform-aws-dynamodb&utm_content=readme_footer_link"><img alt="README footer" src="https://cloudposse.com/readme/footer/img"/></a>

<img alt="Beacon" width="0" src="https://ga-beacon.cloudposse.com/UA-76589703-4/cloudposse/terraform-aws-dynamodb?pixel&cs=github&cm=readme&an=terraform-aws-dynamodb"/>
