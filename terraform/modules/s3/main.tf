resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.s3_bucket
}
