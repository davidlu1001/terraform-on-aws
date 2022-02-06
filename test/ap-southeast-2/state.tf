#terraform {
#  backend "s3" {
#    bucket         = "state-bucket-app-test"
#    key            = "ap-southeast-2/test"
#    region         = "ap-southeast-2"
#    encrypt        = true
#    dynamodb_table = "state-lock-app-test"
#  }
#}
#
