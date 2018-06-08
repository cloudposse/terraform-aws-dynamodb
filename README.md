# terraform-aws-dynamodb [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-dynamodb.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-dynamodb)

Terraform module to provision a DynamoDB table with autoscaling.

Autoscaler scales up/down the provisioned OPS for the DynamoDB table based on the load.

## Requirements

This module requires [AWS Provider](https://github.com/terraform-providers/terraform-provider-aws) `>= 1.17.0`

## Usage

```hcl
module "dynamodb_table" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=master"
  namespace                    = "cp"
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
}
```

## Advanced Usage - with additional attributes and indexes

```hcl
module "dynamodb_table" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-dynamodb.git?ref=master"
  namespace                    = "cp"
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

  dynamodb_attributes          = [
      {
        name = "DailyAverage"
        type = "N"
      },
      {
        name = "HighWater"
        type = "N"
      }
    ]

  global_secondary_index_map   = [
      {
        name               = "DailyAverageIndex"
        hash_key           = "DailyAverage"
        write_capacity     = 5
        read_capacity      = 5
        projection_type    = "KEYS_ONLY"
      },
      {
        name               = "HighWaterIndex"
        hash_key           = "HighWater"
        write_capacity     = 5
        read_capacity      = 5
        projection_type    = "KEYS_ONLY"
      }
  ]
}
```

## Variables

|  Name                           |  Default     |  Description                                                                   | Required |
|:--------------------------------|:-------------|:-------------------------------------------------------------------------------|:--------:|
| `namespace`                     | ``           | Namespace (_e.g._ `cp` or `cloudposse`)                                        | Yes      |
| `stage`                         | ``           | Stage (_e.g._ `prod`, `dev`, `staging`)                                        | Yes      |
| `name`                          | ``           | Name  (_e.g._ `app` or `cluster`)                                              | Yes      |
| `hash_key`                      | ``           | DynamoDB table Hash Key                                                        | Yes      |
| `range_key`                     | ``           | DynamoDB table Range Key                                                       | Yes      |
| `ttl_attribute`                 | ``           | DynamoDB table TTL attribute                                                   | No       |
| `enable_streams`                | `false`      | Enable DynamoDB streams                                                        | No       |
| `stream_view_type`              | ``           | When an item in the table is modified, what information is written to the stream | If `enable_streams` is true |
| `enable_encryption`             | `true`       | Enable DynamoDB server-side encryption                                         | No       |
| `enable_point_in_time_recovery` | `true`       | Enable DynamoDB point-in-time recovery                                         | No       |
| `attributes`                    | `[]`         | Additional attributes (_e.g._ `policy` or `role`)                              | No       |
| `tags`                          | `{}`         | Additional tags  (_e.g._ `map("BusinessUnit","XYZ")`                           | No       |
| `delimiter`                     | `-`          | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`    | No       |
| `autoscale_write_target`        | `50`         | The target value (in %) for DynamoDB write autoscaling                         | No       |
| `autoscale_read_target`         | `50`         | The target value (in %) for DynamoDB read autoscaling                          | No       |
| `autoscale_min_read_capacity`   | `5`          | DynamoDB autoscaling min read capacity                                         | No       |
| `autoscale_max_read_capacity`   | `20`         | DynamoDB autoscaling max read capacity                                         | No       |
| `autoscale_min_write_capacity`  | `5`          | DynamoDB autoscaling min write capacity                                        | No       |
| `autoscale_max_write_capacity`  | `20`         | DynamoDB autoscaling max write capacity                                        | No       |
| `enable_autoscaler`             | `true`       | Flag to enable/disable DynamoDB autoscaling                                    | No       |
| `dynamodb_attributes`           | `[]`         | List of maps that describe extra DynamoDB attributes                           | No       |
| `global_secondary_index_map`    | `[]`         | List of maps that describes additional secondary index properties              | No       |


## A note about DynamoDB attributes

Only define attributes on the table object that are going to be used as:

* Table hash key or range key
* LSI or GSI hash key or range key

The DynamoDB API expects attribute structure (name and type) to be passed along when creating or updating GSI/LSIs or creating the initial table. In these cases it expects the Hash / Range keys to be provided; because these get re-used in numerous places (i.e the table's range key could be a part of one or more GSIs), they are stored on the table object to prevent duplication and increase consistency. If you add attributes here that are not used in these scenarios it can cause an infinite loop in planning.

Additional details see [dynamodb_table](https://www.terraform.io/docs/providers/aws/r/dynamodb_table.html)

## Outputs

| Name            | Description                  |
|:----------------|:-----------------------------|
| `table_id`      | DynamoDB table ID            |
| `table_arn`     | DynamoDB table ARN           |
| `table_name`    | DynamoDB table name          |


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-dynamodb/issues), send us an [email](mailto:hello@cloudposse.com) or reach out to us on [Gitter](https://gitter.im/cloudposse/).


## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-dynamodb/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing `terraform-aws-dynamodb`, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull request** so that we can review your changes

**NOTE:** Be sure to merge the latest from "upstream" before making a pull request!


## License

[APACHE 2.0](LICENSE) © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## About

`terraform-aws-dynamodb` is maintained and funded by [Cloud Posse, LLC][website].

![Cloud Posse](https://cloudposse.com/logo-300x69.png)


Like it? Please let us know at <hello@cloudposse.com>

We love [Open Source Software](https://github.com/cloudposse/)!

See [our other projects][community]
or [hire us][hire] to help build your next cloud-platform.

  [website]: http://cloudposse.com/
  [community]: https://github.com/cloudposse/
  [hire]: http://cloudposse.com/contact/


## Contributors

| [![Erik Osterman][erik_img]][erik_web]<br/>[Erik Osterman][erik_web] | [![Andriy Knysh][andriy_img]][andriy_web]<br/>[Andriy Knysh][andriy_web] |
|-------------------------------------------------------|------------------------------------------------------------------|

  [erik_img]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [erik_web]: https://github.com/osterman/
  [andriy_img]: https://avatars0.githubusercontent.com/u/7356997?v=4&u=ed9ce1c9151d552d985bdf5546772e14ef7ab617&s=144
  [andriy_web]: https://github.com/aknysh/
