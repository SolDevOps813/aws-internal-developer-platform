variable "codepipeline_bucket_name" {
  description = "Bucket used for pipeline artifacts"
  type        = string
}

variable "portal_bucket_name" {
  description = "S3 bucket for developer portal"
  type        = string
}

variable "portal_repo" {
  description = "GitHub repository for developer portal"
  type        = string
}

variable "api_gateway_domain_name" {
  description = "API Gateway domain"
  type        = string
}

variable "consumer_api_gateway_domain_name" {
  description = "Consumer API Gateway domain"
  type        = string
}
