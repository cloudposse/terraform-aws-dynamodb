output "table_name" {
  value       = concat(aws_dynamodb_table.default.*.name, [""])[0]
  description = "DynamoDB table name"
}

output "table_id" {
  value       = concat(aws_dynamodb_table.default.*.id, [""])[0]
  description = "DynamoDB table ID"
}

output "table_arn" {
  value       = concat(aws_dynamodb_table.default.*.arn, [""])[0]
  description = "DynamoDB table ARN"
}

output "global_secondary_index_names" {
  value       = null_resource.global_secondary_index_names.*.triggers.name
  description = "DynamoDB secondary index names"
}

output "local_secondary_index_names" {
  value       = null_resource.local_secondary_index_names.*.triggers.name
  description = "DynamoDB local index names"
}

output "table_stream_arn" {
  value       = concat(aws_dynamodb_table.default.*.stream_arn, [""])[0]
  description = "DynamoDB table stream ARN"
}

output "table_stream_label" {
  value       = concat(aws_dynamodb_table.default.*.stream_label, [""])[0]
  description = "DynamoDB table stream label"
}
