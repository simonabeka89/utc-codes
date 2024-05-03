# Create the ALB security group
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    from_port = 80
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# Create the bastion host security group
resource "aws_security_group" "bastion_sg" {
  name_prefix = "bastion-sg-"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# Create the app server security group
resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}

# Create the database security group
resource "aws_security_group" "db_sg" {
  name_prefix = "db-sg-"
  vpc_id      = aws_vpc.utc_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    env  = "dev"
    team = "config management"
  }
}