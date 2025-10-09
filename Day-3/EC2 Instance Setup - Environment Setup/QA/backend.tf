terraform {
  backend "s3" {
    bucket  = "my-terraform-states"
    key     = "qa/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}