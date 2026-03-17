variable "deployment_bucket_name" {
  description = "S3 bucket used for deployment artifacts"
  type        = string
}

variable "codepipeline_bucket_name" {
  description = "S3 bucket used for CodePipeline artifacts"
  type        = string
  default     = "codepipeline-equinox-test"
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "domain_name" {
  description = "Domain for certificates"
  type        = string
  default     = "equinox.insure"
}

variable "api_gateway_domain_name" {
  description = "API Gateway domain"
  type        = string
  default     = "test-api.equinox.insure"
}

variable "consumer_api_gateway_domain_name" {
  description = "Consumer API domain"
  type        = string
  default     = "test-consumer-api.equinox.insure"
}
