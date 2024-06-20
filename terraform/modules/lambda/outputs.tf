output "fetch_exchange_rates_arn" {
  value = aws_lambda_function.fetch_exchange_rates.arn
}

output "api_function_arn" {
  value = aws_lambda_function.api_function.arn
}

output "api_function_name" {
  value = aws_lambda_function.api_function.function_name
}

output "fetch_exchange_rates_function_name" {
  value = aws_lambda_function.fetch_exchange_rates.function_name
}

output "api_function_invoke_arn" {
  value = aws_lambda_function.api_function.invoke_arn
}
