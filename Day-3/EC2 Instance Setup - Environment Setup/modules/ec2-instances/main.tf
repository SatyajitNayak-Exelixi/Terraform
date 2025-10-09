provider "aws" {
  region = var.region
}

resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  tags = {
    Name        = var.env_tag
    Environment = var.env_tag
  }
}

output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}