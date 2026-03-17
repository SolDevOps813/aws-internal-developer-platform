#This is where the infrastructure is defined.

#Provider

provider "aws" {
  region = var.region
}

#IAM Role for Lambda
#Lambda needs permissions.

resource "aws_iam_role" "lambda_role" {
  name = "${var.tenant_name}-${var.service_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

#Lambda Logging Policy
#This enables logs in cloudwatch

resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

#Lambda Function
#This creates your AWS Lambda service.

resource "aws_lambda_function" "service_lambda" {

  function_name = "${var.tenant_name}-${var.service_name}"

  runtime = var.lambda_runtime
  handler = var.lambda_handler

  role = aws_iam_role.lambda_role.arn

  filename         = var.lambda_source_path
  source_code_hash = filebase64sha256(var.lambda_source_path)

}

#API Gateway
#Create the API.

resource "aws_apigatewayv2_api" "service_api" {

  name          = "${var.tenant_name}-${var.service_name}-api"
  protocol_type = "HTTP"

}

#API Integration
#Connect API → Lambda.

resource "aws_apigatewayv2_integration" "lambda_integration" {

  api_id           = aws_apigatewayv2_api.service_api.id
  integration_type = "AWS_PROXY"

  integration_uri = aws_lambda_function.service_lambda.invoke_arn

  payload_format_version = "2.0"

}

#API Route
#Define route.

resource "aws_apigatewayv2_route" "default_route" {

  api_id    = aws_apigatewayv2_api.service_api.id
  route_key = "ANY /"

  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"

}

#API Stage

resource "aws_apigatewayv2_stage" "prod" {

  api_id = aws_apigatewayv2_api.service_api.id
  name   = "$default"

  auto_deploy = true

}

#Allow API Gateway to Call Lambda
#Now API Gateway can invoke Lambda.

resource "aws_lambda_permission" "api_gw_permission" {

  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.service_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.service_api.execution_arn}/*/*"

}

