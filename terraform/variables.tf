variable "s3_bucket" {
  description = "The name of the S3 bucket where the Lambda functions are stored"
  default     = "cet-terraform-state-bucket"
}

variable "dynamodb_table" {
  description = "The name of the DynamoDB table"
  default     = "ExchangeRates"
}
