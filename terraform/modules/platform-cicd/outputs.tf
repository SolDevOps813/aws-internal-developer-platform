output "pipeline_name" {
  value = aws_codepipeline.portal_pipeline.name
}

output "codebuild_project" {
  value = aws_codebuild_project.portal_build.name
}
