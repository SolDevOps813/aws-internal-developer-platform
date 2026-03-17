resource "aws_codebuild_project" "portal_build" {

  name         = "portal-deployment"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "portal/buildspec.yaml"  # ✅ FIXED
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    # ✅ ADD THIS
    environment_variable {
      name  = "S3_BUCKET"
      value = var.portal_bucket_name
    }

    # ✅ FIXED NAME
    environment_variable {
      name  = "CLOUDFRONT_DISTRIBUTION_ID"
      value = var.cloudfront_distribution_id
    }
  }
}

resource "aws_iam_role" "codebuild_role" {

  name = "portal-codebuild-role"

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

resource "aws_iam_role_policy" "codebuild_policy" {

  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      },

      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Resource = "*"
      }

    ]

  })
}

resource "aws_codepipeline" "portal_pipeline" {

  name     = "developer-portal-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {

    location = aws_s3_bucket.pipeline_bucket.bucket

    type = "S3"

  }

  stage {

    name = "Source"

    action {

      name             = "GitHub"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"

      output_artifacts = ["source_output"]

      version = "1"

      configuration = {

        Owner  = "yourgithub"
        Repo   = "platform-engineering-project"
        Branch = "main"

      }

    }

  }

  stage {

    name = "Build"

    action {

      name             = "DeployPortal"

      category = "Build"

      owner = "AWS"

      provider = "CodeBuild"

      input_artifacts = ["source_output"]

      version = "1"

      configuration = {

        ProjectName = aws_codebuild_project.portal_build.name

      }

    }

  }

}
