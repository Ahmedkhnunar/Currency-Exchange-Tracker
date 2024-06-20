provider "aws" {
  region = "eu-north-1" # Update to your preferred region: us-east-1
}

module "s3" {
  source    = "./modules/s3"
  s3_bucket = var.s3_bucket
}

module "dynamodb" {
  source         = "./modules/dynamodb"
  dynamodb_table = var.dynamodb_table
}

module "iam" {
  source             = "./modules/iam"
  dynamodb_table_arn = module.dynamodb.dynamodb_table_arn
}

module "lambda" {
  source                    = "./modules/lambda"
  dynamodb_table            = var.dynamodb_table
  lambda_role_arn           = module.iam.lambda_role_arn
}

module "api_gateway" {
  source                = "./modules/api_gateway"
  lambda_function_arn   = module.lambda.api_function_arn
  lambda_function_name  = module.lambda.api_function_name
  lambda_invoke_arn     = module.lambda.api_function_invoke_arn
}

module "cloudwatch" {
  source                           = "./modules/cloudwatch"
  fetch_exchange_rates_arn         = module.lambda.fetch_exchange_rates_arn
  fetch_exchange_rates_function_name = module.lambda.fetch_exchange_rates_function_name
}