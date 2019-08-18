output "dynamodb_table_name" {
 value = "${aws_dynamodb_table.bc_table.name}"
 description = "The DynamoDB Table Name"
}
