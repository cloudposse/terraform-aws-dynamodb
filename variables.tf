variable "region" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

variable "stage" {
  type = "string"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "tags" {
  type    = "map"
  default = {}
}

variable "delimiter" {
  type    = "string"
  default = "-"
}

variable "hash_key" {
  type = "string"
}

variable "range_key" {
  type = "string"
}

variable "ttl_attribute" {
  type    = "string"
  default = "Expires"
}

variable "autoscale_write_target" {
  default = 50
}

variable "autoscale_read_target" {
  default = 50
}

variable "autoscale_min_read_capacity" {
  default = 10
}

variable "autoscale_max_read_capacity" {
  default = 100
}

variable "autoscale_min_write_capacity" {
  default = 10
}

variable "autoscale_max_write_capacity" {
  default = 100
}
