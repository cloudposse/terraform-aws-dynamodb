variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`, `infra`)"
}

variable "name" {
  type        = "string"
  description = "Name  (e.g. `app` or `cluster`)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `stage`, `name`, and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. map('BusinessUnit`,`XYZ`)"
}

variable "autoscale_write_target" {
  default     = 50
  description = "The target value (in %) for DynamoDB write autoscaling"
}

variable "autoscale_read_target" {
  default     = 50
  description = "The target value (in %) for DynamoDB read autoscaling"
}

variable "autoscale_min_read_capacity" {
  default     = 5
  description = "DynamoDB autoscaling min read capacity"
}

variable "autoscale_max_read_capacity" {
  default     = 20
  description = "DynamoDB autoscaling max read capacity"
}

variable "autoscale_min_write_capacity" {
  default     = 5
  description = "DynamoDB autoscaling min write capacity"
}

variable "autoscale_max_write_capacity" {
  default     = 20
  description = "DynamoDB autoscaling max write capacity"
}

variable "stream_enabled" {
  type        = "string"
  default     = "false"
  description = "Enable DynamoDB streams"
}

variable "enable_encryption" {
  type        = "string"
  default     = "true"
  description = "Enable DynamoDB server-side encryption"
}

variable "enable_point_in_time_recovery" {
  type        = "string"
  default     = "true"
  description = "Enable DynamoDB point in time recovery"
}

variable "hash_key" {
  type        = "string"
  description = "DynamoDB table Hash Key"
}

variable "range_key" {
  type        = "string"
  description = "DynamoDB table Range Key"
}

variable "ttl_attribute" {
  type        = "string"
  default     = "Expires"
  description = "DynamoDB table TTL attribute"
}

variable "enable_autoscaler" {
  type        = "string"
  default     = "true"
  description = "Flag to enable/disable DynamoDB autoscaling"
}

variable "dynamodb_attributes" {
  type        = "list"
  default     = []
  description = "Additional DynamoDB attributes in the form of a list of mapped values"
}

variable "global_secondary_index_map" {
  type        = "list"
  default     = []
  description = "Additional global secondary indexes in the form of a list of mapped values"
}
