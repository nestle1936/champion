terraform {
  cloud {
    organization = "champion-group"
    workspaces {
      name = "champion2"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      #   version = "4.15.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "vpc-champion"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-ec2"
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network"
  }
}

resource "aws_instance" "foo" {
  ami           = "ami-0022f774911c1d690"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
  key_name = "Jenkinskey"
  tags = {
    "Name" = "champion"
  }
}