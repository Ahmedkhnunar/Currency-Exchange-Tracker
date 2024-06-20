resource "aws_cloudwatch_event_rule" "daily_fetch" {
  name                = "DailyFetchRule"
  description         = "Triggers fetch_exchange_rates Lambda function daily"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "fetch_target" {
  rule      = aws_cloudwatch_event_rule.daily_fetch.name
  target_id = "FetchExchangeRatesFunction"
  arn       = var.fetch_exchange_rates_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_fetch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.fetch_exchange_rates_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_fetch.arn
}
