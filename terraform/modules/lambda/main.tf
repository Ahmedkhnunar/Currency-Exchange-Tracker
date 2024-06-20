resource "aws_lambda_function" "fetch_exchange_rates" {
  filename         = "lambda/fetch_exchange_rates.zip"
  function_name    = "FetchExchangeRates"
  role             = var.lambda_role_arn
  handler          = "fetch_exchange_rates.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("lambda/fetch_exchange_rates.zip")

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table
    }
  }

  layers = [
    "arn:aws:lambda:eu-north-1:770693421928:layer:Klayers-p312-requests:5"
  ]
}

resource "aws_lambda_function" "api_function" {
  filename         = "lambda/api_function.zip"
  function_name    = "ApiFunction"
  role             = var.lambda_role_arn
  handler          = "api_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("lambda/api_function.zip")

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table
    }
  }
}
