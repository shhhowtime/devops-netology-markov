resource "aws_vpc" "VPC" {
  cidr_block = "172.31.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
}

data "aws_subnet_ids" "subnets" {
  vpc_id = aws_vpc.VPC.id
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.VPC.id
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

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "172.31.96.0/19"
}

resource "aws_eip" "NAT_IP" {
  vpc = true
}

resource "aws_nat_gateway" "NAT_GW" {
  allocation_id = aws_eip.NAT_IP.id
  subnet_id = aws_subnet.public.id
}

resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT_GW.id
  }
}

resource "aws_route_table_association" "PublicRTassociation" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "PrivateRTassociation" {
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  description = "vpn-endpoint"
  server_certificate_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/faa1d1ea-1448-4539-b1d7-68ec921c36e4"
  client_cidr_block = "172.31.0.0/19"

  authentication_options {
    type = "certificate-authentication"
    root_certificate_chain_arn = "arn:aws:acm:eu-central-1:176502011080:certificate/52de4e17-2363-4580-9f51-24e9dff9bf9b"
  }

  connection_log_options {
    enabled = false
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn_to_private_association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  subnet_id = aws_subnet.private.id
}

resource "aws_ec2_client_vpn_authorization_rule" "default_vpn_authorization_rule" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
  target_network_cidr = aws_subnet.private.cidr_block
  authorize_all_groups = true
}

resource "aws_s3_bucket" "markov-bucket" {
  bucket = "fmarkov-netology"
  acl = "private"
}

resource "aws_key_pair" "ssh-key" {
  key_name = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIgLxGwc5LLTN0j6/rI5DRm+c3NIju4Bz5x+GIhb6C8G theo@theo-speed-demon"
}

resource "aws_s3_bucket_object" "my-picture" {
  bucket = aws_s3_bucket.markov-bucket.id
  key = "markov"
  source = "markov.jpeg"
  acl = "public_read"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_network_interface" "private" {
  subnet_id = aws_subnet.private.id
}


resource "aws_security_group" "instance_security_group" {
  name = "autoscalling_security_group"
  vpc_id = "${aws_vpc.VPC.id}"
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "LC-Markov" {
  name = "Fmarkov-LC-"
  image_id = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "ssh-key"
  security_groups = ["${aws_security_group.instance_security_group.id}"]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install docker.io -y
              sudo docker run -d --name nginx --network host shhhowtime/nginx-netology-aws
              EOF
}


resource "aws_security_group" "elb-security-group" {
  name = "autoscallinggroupelb"
  vpc_id = "${aws_vpc.VPC.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_elb" "ELB-Markov" {
  name = "ELB-Markov"
  security_groups = [aws_security_group.elb-security-group.id]
  subnets = [aws_subnet.private.id]
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 15
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}

resource "aws_autoscaling_group" "ASG-Markov" {
  launch_configuration = aws_launch_configuration.LC-Markov.name
  vpc_zone_identifier = ["${aws_subnet.private.id}"]
  name = "Fmarkov-ASG"
  min_size = 2
  max_size = 3
  load_balancers = ["${aws_elb.ELB-Markov.name}"]
  health_check_type = "EC2"
  health_check_grace_period = 1200

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_zone" "markov" {
  name = "fmarkov-netology.local"

  vpc {
    vpc_id = aws_vpc.VPC.id
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.markov.zone_id
  name    = "fmarkov-netology.local"
  type    = "A"
  alias {
    name                   = aws_elb.ELB-Markov.dns_name
    zone_id                = aws_elb.ELB-Markov.zone_id
    evaluate_target_health = true
  }
}
