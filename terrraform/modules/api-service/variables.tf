variable "service_name" {
  description = "Name of the service"
  type        = string
}

variable "tenant_name" {
  description = "Tenant identifier"
  type        = string
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "app.lambda_handler"
}

variable "lambda_source_path" {
  description = "Path to Lambda source code zip"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}


#These variables let your platform CLI dynamically create services.
#Example:
#tenantA
#billing-api