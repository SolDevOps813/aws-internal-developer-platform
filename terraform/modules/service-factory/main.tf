resource "aws_lambda_function" "service_factory" {

  function_name = "platform-service-factory"

  runtime = "python3.11"
  handler = "lambda_function.handler"

  filename = "${path.module}/lambda.zip"

  role = var.lambda_role_arn
}

resource "aws_apigatewayv2_api" "platform_api" {

  name          = "platform-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "factory" {

  api_id = aws_apigatewayv2_api.platform_api.id

  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.service_factory.invoke_arn
}

resource "aws_apigatewayv2_route" "create_service" {

  api_id = aws_apigatewayv2_api.platform_api.id

  route_key = "POST /platform/create-service"

  target = "integrations/${aws_apigatewayv2_integration.factory.id}"
}
