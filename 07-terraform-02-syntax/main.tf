provider "aws" {
  region = "eu-central-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

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

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_ami" "ubuntu" {
  name             = "ubuntu"
  root_device_name = "/dev/xvda"

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "fmarkov-vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "eu-central-1"

  tags = {
    Name = "fmarkov-subnet"
  }
}

resource "aws_network_interface" "local" {
  subnet_id   = aws_subnet.subnet.id
  private_ips = ["10.0.100.1"]

  tags = {
    Name = "network_interface_fmarkov"
  }
}

resource "aws_instance" "netpology_fmarkov" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "Fyodor Markov for Netology homework"
  }

  network_interface {
    network_interface_id = aws_network_interface.local.id
    device_index         = 0
  }
}

