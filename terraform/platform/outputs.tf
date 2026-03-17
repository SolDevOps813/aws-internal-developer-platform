output "portal_url" {
  description = "Developer portal URL"
  value       = module.developer_portal.portal_url
}

output "service_factory_api" {
  description = "API endpoint for service factory"
  value       = module.service_factory.api_endpoint
}

output "codepipeline_artifact_bucket" {
  description = "Artifact bucket used by pipelines"
  value       = module.platform_cicd.codepipeline_bucket_name
}

output "codebuild_role" {
  description = "CodeBuild IAM role"
  value       = module.platform_cicd.codebuild_role_arn
}

output "codepipeline_role" {
  description = "CodePipeline IAM role"
  value       = module.platform_cicd.codepipeline_role_arn
}
