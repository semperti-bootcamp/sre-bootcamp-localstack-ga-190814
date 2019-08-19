output "dynamodb_table_name" {
 value = "${aws_dynamodb_table.BootCampMusicTable.name}"
 description = "The DynamoDB Table Name"
}
