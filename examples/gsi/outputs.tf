output "table_name" {
  value       = module.dynamodb_table_with_experimental_gsi.table_name
  description = "DynamoDB table name"
}

output "table_arn" {
  value       = module.dynamodb_table_with_experimental_gsi.table_arn
  description = "DynamoDB table ARN"
}

output "global_secondary_index_arns" {
  value       = module.dynamodb_table_with_experimental_gsi.global_secondary_index_arns
  description = "ARNs of Global Secondary Indexes created using experimental resource"
}
