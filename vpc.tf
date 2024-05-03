# Provider Configuration
provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
resource "aws_vpc" "utc_vpc" {
  cidr_block = "10.10.0.0/16"
  
  tags = {
    Name = "utc-vpc"
    env  = "dev"
    team = "config management"
  }
}

# Public Subnets Configuration
resource "aws_subnet" "public_subnet_1a" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "utc-public-subnet-1a"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_subnet" "public_subnet_1b" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "utc-public-subnet-1b"
    env  = "dev"
    team = "config management"
  }
}

# Private Subnets Configuration
resource "aws_subnet" "private_subnet_1a" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "utc-private-subnet-1a"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_subnet" "private_subnet_1b" {
  vpc_id     = aws_vpc.utc_vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "utc-private-subnet-1b"
    env  = "dev"
    team = "config management"
  }
}

# Internet Gateway Configuration
resource "aws_internet_gateway" "utc_igw" {
  vpc_id = aws_vpc.utc_vpc.id

  tags = {
    Name = "utc-internet-gateway"
    env  = "dev"
    team = "config management"
  }
}

# Route Tables Configuration
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.utc_vpc.id

  tags = {
    Name = "utc-public-route-table"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.utc_vpc.id

  tags = {
    Name = "utc-private-route-table"
    env  = "dev"
    team = "config management"
  }
}

# Route Table Association Configuration
resource "aws_route_table_association" "public_subnet_1a_association" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet_1b_association" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_1a_association" {
  subnet_id = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}