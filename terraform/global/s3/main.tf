terraform {
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "aws" {
  region = "us-east-1"
  profile = "rkepler"
}

/*
Creates the S3 bucket to store state. This is a simple example without
taking into account deployment environments, which needs a better folder
structure, one for each env for example. Here we just want to see how it works
*/
resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  //This is only here so we can destroy the bucket as part of automated tests.
  //You should not copy this for production usage
  force_destroy = true
  //lifecycle {
  // prevent_destroy = true
  //}

}

/*
To use DynamoDB for locking with Terraform, you must create a DynamoDB table that has a
primary key called LockID (with this exact spelling and capitalization). You can create such
a table using the aws_dynamodb_table resource:
*/

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}