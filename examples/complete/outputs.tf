output "table_name_1" {
  value       = module.dynamodb_table_1.table_name
  description = "DynamoDB table name"
}

output "table_id_1" {
  value       = module.dynamodb_table_1.table_id
  description = "DynamoDB table ID"
}

output "table_arn_1" {
  value       = module.dynamodb_table_1.table_arn
  description = "DynamoDB table ARN"
}

output "global_secondary_index_names_1" {
  value       = module.dynamodb_table_1.global_secondary_index_names
  description = "DynamoDB secondary index names"
}

output "table_stream_arn_1" {
  value       = module.dynamodb_table_1.table_stream_arn
  description = "DynamoDB table stream ARN"
}

output "table_stream_label_1" {
  value       = module.dynamodb_table_1.table_stream_label
  description = "DynamoDB table stream label"
}

output "table_name_2" {
  value       = module.dynamodb_table_2.table_name
  description = "DynamoDB table name"
}

output "table_id_2" {
  value       = module.dynamodb_table_2.table_id
  description = "DynamoDB table ID"
}

output "table_arn_2" {
  value       = module.dynamodb_table_2.table_arn
  description = "DynamoDB table ARN"
}

output "global_secondary_index_names_2" {
  value       = module.dynamodb_table_2.global_secondary_index_names
  description = "DynamoDB secondary index names"
}

output "table_stream_arn_2" {
  value       = module.dynamodb_table_2.table_stream_arn
  description = "DynamoDB table stream ARN"
}

output "table_stream_label_2" {
  value       = module.dynamodb_table_2.table_stream_label
  description = "DynamoDB table stream label"
}
