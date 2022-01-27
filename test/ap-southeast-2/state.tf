terraform {
  backend "s3" {
    bucket         = "terraform-app-test"
    key            = "ap-southeast-2/test"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "tfstate-lock-app-test"
  }
}
