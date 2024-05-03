# Create a VPC and subnets
resource "aws_vpc" "bastion_server" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "bastion_server"
  }
}

resource "aws_subnet" "private" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.bastion_server.id
}

resource "aws_subnet" "public" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.bastion_server.id
}

# Create a security group for the bastion host
resource "aws_security_group" "bastion" {
  name_prefix = "bastion-"
  vpc_id      = aws_vpc.bastion_server.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create the bastion host
resource "aws_instance" "bastion" {
  ami           = "ami-00c39f71452c08778" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
  key_name      = "utc-key"
  vpc_security_group_ids = [aws_security_group.bastion.id]
  tags = {
    Name = "bastion_server"
    env  = "dev"
    team = "config management"
  }
}



