variable "localstack_server" {
  description = "LocalStack Server Name or IP"
  type        = string
  default     = "localstack"
}
variable "dynamodb_table_name" {
  description = "Table Name for BootCamp"
  type        = string
  default     = "BootCampMusic"
}
