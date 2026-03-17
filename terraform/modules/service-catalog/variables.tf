variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
  default     = "platform-service-catalog"
}

variable "hash_key" {
  description = "Primary key for the table"
  type        = string
  default     = "service_id"
}
