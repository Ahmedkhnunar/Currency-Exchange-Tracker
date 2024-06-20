resource "aws_dynamodb_table" "exchange_rates" {
  name           = var.dynamodb_table
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "Date"

  attribute {
    name = "Date"
    type = "S"
  }
}
