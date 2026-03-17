variable "lambda_role_arn" {
  description = "IAM role for Lambda execution"
  type        = string
}

variable "service_catalog_table" {
  description = "DynamoDB table name"
  type        = string
}
