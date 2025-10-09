provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source = "../modules/ec2-instance"

  ami_id             = "ami-0c55b159cbfafe1f0"
  instance_type      = "t2.micro"
  key_name           = "my-keypair-dev"
  security_group_id  = "sg-0dev1234567890"
  subnet_id          = "subnet-0dev1234567890"
  env_tag            = "Prod"
  region             = "us-east-1"
}