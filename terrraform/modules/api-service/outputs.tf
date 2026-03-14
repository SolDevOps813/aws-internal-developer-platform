#This exposes useful values to the platform layer.

output "api_endpoint" {

  description = "API endpoint URL"

  value = aws_apigatewayv2_api.service_api.api_endpoint

}


#Optional additional outputs:

output "lambda_function_name" {

  value = aws_lambda_function.service_lambda.function_name

}