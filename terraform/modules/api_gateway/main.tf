resource "aws_api_gateway_rest_api" "exchange_rates_api" {
  name        = "ExchangeRatesApi"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  description = "API for fetching exchange rates"
}

resource "aws_api_gateway_resource" "exchange_rates_resource" {
  rest_api_id = aws_api_gateway_rest_api.exchange_rates_api.id
  parent_id    = aws_api_gateway_rest_api.exchange_rates_api.root_resource_id
  path_part    = "rates"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.exchange_rates_api.id
  resource_id   = aws_api_gateway_resource.exchange_rates_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id           = aws_api_gateway_rest_api.exchange_rates_api.id
  resource_id           = aws_api_gateway_resource.exchange_rates_resource.id
  http_method           = aws_api_gateway_method.get_method.http_method
  integration_http_method = "GET"
  type                   = "AWS"
  uri                    = var.lambda_invoke_arn

  # Optional: Configure request payload format if needed
  # request_parameters = {
  #   "method.request.header.Content-Type" = "'application/json'"
  #   "method.request.body.passthrough" = "true"
  # }
}

# Optional: Define API Gateway Method Response
resource "aws_api_gateway_method_response" "get_method_response" {
  rest_api_id = aws_api_gateway_rest_api.exchange_rates_api.id
  resource_id = aws_api_gateway_resource.exchange_rates_resource.id
  http_method = aws_api_gateway_method.get_method.http_method
  status_code = "200"
}


// Deploy API Gateway
resource "aws_api_gateway_deployment" "exchange_rates_deployment" {
  depends_on = [aws_api_gateway_integration.lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.exchange_rates_api.id
  stage_name  = "prod"  // Replace with your desired stage name
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
}