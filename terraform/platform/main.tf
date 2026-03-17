#assembling the entire platform.

provider "aws" {
  region = var.aws_region
}

##################################################
# Platform CI/CD Core Infrastructure
##################################################

module "platform_cicd" {
  source = "../modules/platform-cicd"

  environment                     = var.environment
  deployment_bucket_name          = var.deployment_bucket_name
  codepipeline_bucket_name        = var.codepipeline_bucket_name
  api_gateway_domain_name         = var.api_gateway_domain_name
  consumer_api_gateway_domain_name = var.consumer_api_gateway_domain_name
}

##################################################
# Developer Portal Infrastructure
##################################################

module "developer_portal" {
  source = "../modules/developer-portal"

  portal_bucket_name = var.portal_bucket_name
}

##################################################
# Portal CI/CD Pipeline
##################################################

module "portal_cicd" {
  source = "../modules/portal-cicd"

  project_name = "developer-portal"

  artifact_bucket = module.platform_cicd.codepipeline_bucket_name

  codebuild_role_arn   = module.platform_cicd.codebuild_role_arn
  codepipeline_role_arn = module.platform_cicd.codepipeline_role_arn

  portal_bucket_name = module.developer_portal.portal_bucket_name

  cloudfront_distribution_id = module.developer_portal.cloudfront_distribution_id

  source_repo = var.portal_repo
}

##################################################
# Service Catalog (DynamoDB)
##################################################

#module "service_catalog" {
#  source = "../modules/service-catalog"
#}

##################################################
# Service Factory
##################################################

#module "service_factory" {
#  source = "../modules/service-factory"

#  lambda_role_arn = module.platform_cicd.lambda_role_arn
#}

module "service_catalog" {
  source = "../modules/service-catalog"
}

module "service_factory" {
  source = "../modules/service-factory"

  lambda_role_arn       = module.platform_cicd.lambda_role_arn
  service_catalog_table = module.service_catalog.table_name
}
