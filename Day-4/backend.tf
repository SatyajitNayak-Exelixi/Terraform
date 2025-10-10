terraform {
  backend "s3" {
    bucket         = "exelixi-s3-object" # change this
    key            = "exelixi/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}