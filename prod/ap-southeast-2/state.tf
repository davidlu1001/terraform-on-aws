terraform {
  backend "s3" {
    bucket         = "terraform-app-prod"
    key            = "ap-southeast-2/prod"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "tfstate-lock-app-prod"
  }
}
