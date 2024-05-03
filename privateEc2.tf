provider "aws" {
    alias = "east"
    region = us-east-1
}
  
resource "aws_instance" "appserver-1a" {
  ami           = "ami-04581fbf744a7d11f"
  instance_type = "t2.micro"
  key_name      = "utc-key"
  vpc_security_group_ids = [aws_security_group.app-server.id]
  subnet_id     = aws_subnet.private-1a.id
  user_data     = file("${path.module}/apache.sh") 
                  
  tags = {
    Name = "appserver-1a"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_instance" "appserver-1b" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  key_name      = "utc-key"
  vpc_security_group_ids = [aws_security_group.app-server.id]
  subnet_id     = aws_subnet.private-1b.id
  user_data     =  file("${path.module}/apache.sh") 
  tags = {
    Name = "appserver-1b"
    env  = "dev"
    team = "config management"
  }
}

resource "aws_security_group" "app-server" {
  name_prefix = "app-server-sg"
  vpc_id      = aws_vpc.utc-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id = aws_vpc.utc-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private-1b" {
  vpc_id = aws_vpc.utc-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_vpc" "utc-vpc" {
  cidr_block = "10.0.0.0/16"
}