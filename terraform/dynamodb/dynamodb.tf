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
        dynamodb = "http://${var.localstack_server}:4569" 
    }
}

resource "aws_dynamodb_table" "BootCampMusicTable" {
    name           = "${var.dynamodb_table_name}"
    billing_mode   = "PROVISIONED"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "Artist"
    range_key       = "SongTitle"

    attribute {
        name = "Artist"
        type = "S"
    }

    attribute {
        name = "SongTitle"
        type = "S"
    }


    tags = {
      Name        = "var.dynamodb_table_tag_name"
      Environment = "var.dynamodb_table_env_name"
    }
}


