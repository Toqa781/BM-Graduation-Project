terraform {
  backend "s3" {
    bucket="statefile-bucket-bmfinal"
    key="./terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "statefile-table"
  }
}