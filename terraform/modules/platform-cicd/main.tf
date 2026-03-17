#define region:
data "aws_region" "current" {}

#S3 Buckets
resource "aws_s3_bucket" "deployment_bucket" {
  bucket = var.deployment_bucket_name
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = var.codepipeline_bucket_name
}

#CloudFormation Deploy Role
resource "aws_iam_role" "cfn_role" {
  name = "cloudformation-serverless-deploy-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = [
            "cloudformation.amazonaws.com",
            "lambda.amazonaws.com"
          ]
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach policy:
resource "aws_iam_role_policy" "cfn_policy" {

  role = aws_iam_role.cfn_role.id
  name = "cloudformation-serverless-deploy-${data.aws_region.current.name}"

  policy = file("${path.module}/policies/cfn_policy.json")
}


#Lambda Execution Role (Recommended to move the huge policy into a JSON file for readability.)
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Lambda Policy:
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#CodePipeline Role
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-service-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#CodeBuild Role
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Attach AWS managed policy:(You can later replace this with your exact policy from the template.)
resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#DynamoDB → Elasticsearch Role

resource "aws_iam_role" "ddb_to_es_role" {

  name = "ddb-to-es-role-${data.aws_region.current.name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#SSM PARAMETERS

resource "aws_ssm_parameter" "cfn_role" {
  name  = "/${var.environment}/CFN_ROLE_ARN"
  type  = "String"
  value = aws_iam_role.cfn_role.arn
}

resource "aws_ssm_parameter" "lambda_role" {
  name  = "/${var.environment}/LAMBDA_ROLE_ARN"
  type  = "String"
  value = aws_iam_role.lambda_role.arn
}

resource "aws_ssm_parameter" "deployment_bucket" {
  name  = "/${var.environment}/DEPLOYMENT_BUCKET"
  type  = "String"
  value = var.deployment_bucket_name
}

resource "aws_ssm_parameter" "api_domain" {
  name  = "/${var.environment}/DOMAIN_NAME"
  type  = "String"
  value = var.api_gateway_domain_name
}

resource "aws_ssm_parameter" "consumer_domain" {
  name  = "/${var.environment}/CONSUMER_DOMAIN_NAME"
  type  = "String"
  value = var.consumer_api_gateway_domain_name
}

resource "aws_ssm_parameter" "service_region" {
  name  = "/${var.environment}/AWS_SERVICE_REGION"
  type  = "String"
  value = data.aws_region.current.name
}

resource "aws_ssm_parameter" "ddb_to_es_role" {
  name  = "/${var.environment}/DDB_TO_ES_ROLE_ARN"
  type  = "String"
  value = aws_iam_role.ddb_to_es_role.arn
}
