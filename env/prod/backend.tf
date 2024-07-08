terraform {
  backend "s3" {
    bucket = "terraform-infra-container"
    key    = "Prod/terraform.tfstate"
    region = "us-west-2"
  }
}
