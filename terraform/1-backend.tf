terraform {
  backend "s3" {
    bucket="statefile-bucket-bmfinal"
    key="./terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "statefile-table"
  }
}