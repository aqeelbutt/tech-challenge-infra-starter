terraform {
  backend "s3" {
    bucket         = var.state_bucket_name
    key            = "terraform.tfstate"
    region         = var.region
    dynamodb_table = var.state_table_name
  }
}