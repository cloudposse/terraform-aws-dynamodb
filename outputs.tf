output "table_name" {
  value       = "${aws_dynamodb_table.default.name}"
  description = "DynamoDB table name"
}

output "table_id" {
  value       = "${aws_dynamodb_table.default.id}"
  description = "DynamoDB table ID"
}

output "table_arn" {
  value       = "${aws_dynamodb_table.default.arn}"
  description = "DynamoDB table ARN"
}

output "global_secondary_index_names" {
  value = ["${null_resource.global_secondary_indexes.*.triggers.name}"]
}

output "table_stream_arn" {
  value = "${aws_dynamodb_table.default.stream_arn}"
}

output "table_stream_label" {
  value = "${aws_dynamodb_table.default.stream_label}"
}
