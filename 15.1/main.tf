resource "aws_vpc" "VPC" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "172.31.32.0/19"
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_network_interface" "public" {
  subnet_id   = aws_subnet.public.id
  private_ips = ["172.31.32.100"]
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

resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgLxGwc5LLTN0j6/rI5DRm+c3NIju4Bz5x+GIhb6C8G theo@theo-speed-demon"
}

resource "aws_instance" "terraform-public" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.public.id
    device_index         = 0
  }

  key_name = "ssh-key"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.VPC.id
  cidr_block = "172.31.96.0/19"
}

resource "aws_eip" "NAT_IP" {
  vpc = true
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.NAT_IP.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW.id
  }
}

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  description            = "vpn-endpoint"
  server_certificate_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/8b1656be-c79d-486e-b6c6-120eec52c8cb"
  client_cidr_block      = "172.31.0.0/19"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/475d8dac-22a4-406c-b9cc-f977148606f6"
  }

  connection_log_options {
    enabled = false
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_to_private_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  subnet_id              = aws_subnet.private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "default_vpn_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  target_network_cidr    = aws_subnet.private.cidr_block
  authorize_all_groups   = true
}

resource "aws_network_interface" "private" {
  subnet_id   = aws_subnet.private.id
  private_ips = ["172.31.96.100"]
}

resource "aws_instance" "terraform-private" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.private.id
    device_index         = 0
  }

  key_name = "ssh-key"
}