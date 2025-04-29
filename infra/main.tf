resource "aws_s3_bucket" "this" {
  bucket = "${var.prefix}-localstack-test-bucket"

  tags = {
    Name        = "My test bucket"
    Environment = "Dev"
  }
}
