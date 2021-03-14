provider "aws" {
  region = "eu-central-1"
}

locals {
  inst_tag = {
    stage = "stage tag"
    prod = "prod tag"
  }

  inst_type = {
    stage = "t2.micro"
    prod = "t4g.micro"
  }

  inst_count = {
    stage = 1
    prod = 2
  }

  foreach_vars = {
    "t2.micro" = data.aws_ami.amazon_linux.id
    "t4g.micro" = data.aws_ami.amazon_linux.id
    "t4g.micro" = data.aws_ami.amazon_linux.id
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "fmarkov-netology"
  acl    = "private"
}

resource "aws_dynamodb_table" "dynamodb" {
  name           = "lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = "fmarkov-netology"
    key            = "terraform/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "lock"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  owners = ["amazon"]
}

resource "aws_instance" "netology_fmarkov" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.inst_type[terraform.workspace]
  count         = local.inst_count[terraform.workspace]

  tags = {
    Name = local.inst_tag[terraform.workspace]
  }
}

resource "aws_instance" "netology_fmarkov_2" {
  lifecycle {
    create_before_destroy = true
  }
  
  for_each = local.foreach_vars

  instance_type = each.value
  ami           = each.key

  tags = {
    Name = local.inst_tag[terraform.workspace]
  }  
}
