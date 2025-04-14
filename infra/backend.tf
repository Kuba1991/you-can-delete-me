terraform {
  backend "s3" {
    bucket         = "terraform-kuba1991"
    key            = "eu-west-1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-kuba1991"
    encrypt        = true
  }
}
