provider "aws" {
  version = "~> 2.7"
  region = "us-east-1"
  s3_force_path_style = true
  access_key = "bootcamp"
  secret_key = "bootcamp"
  skip_credentials_validation = true
  skip_requesting_account_id = true
  skip_metadata_api_check = true
    endpoints {
        s3       = "http://${var.localstack_server}:4572"
    }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.s3_bucket}"
  acl    = "private"

  tags = {
    Name        = "${var.s3_bucket_tag_name}"
    Environment = "${var.s3_bucket_tag_env}"
  }

  versioning { 
    enabled = true
  } 
}

