variable "region" {
  type        = string
  description = "AWS region"
}

variable "namespace" {
  type = string
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`, `infra`)"
}

variable "name" {
  type        = string
  description = "Name  (e.g. `app` or `cluster`)"
}
