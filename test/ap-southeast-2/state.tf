terraform {
  backend "s3" {
    bucket         = "app-terraform-test"
    key            = "ap-southeast-2/test"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "app-state-lock-test"
  }
}
