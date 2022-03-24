#terraform {
#  backend "s3" {
#    bucket         = "state-bucket-app-prod"
#    key            = "ap-southeast-2/prod"
#    region         = "ap-southeast-2"
#    encrypt        = true
#    dynamodb_table = "state-lock-app-prod"
#  }
#}
