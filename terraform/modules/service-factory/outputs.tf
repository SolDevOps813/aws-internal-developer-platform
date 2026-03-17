output "lambda_name" {
  description = "Service factory Lambda name"
  value       = aws_lambda_function.service_factory.function_name
}

output "api_endpoint" {
  description = "API Gateway endpoint"
  value       = aws_apigatewayv2_api.platform_api.api_endpoint
}
