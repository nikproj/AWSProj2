resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP and HTTPS from all-inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "http from public to load balancer"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "https from public to load balancer"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow ssh from my-computer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "webserver_sg" {
  name        = "webserver_sg"
  description = "Allow HTTP and HTTPS from Load Balancer and SSH from Bastion Host"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH from Bastion Host"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }
  ingress {
    description      = "http from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }
  ingress {
    description      = "https from public to load balancer"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "database_sg" {
  name        = "database_sg"
  description = "Allow MYSQL/AURORA from Web Server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "MYSQL/AURORA from Web Server SG"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [aws_security_group.webserver_sg.id]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow NFS from Web Servers"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "NFS from Webserver SG"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.webserver_sg.id]
  }
  ingress {
    description      = "Self from EFS"
    protocol         = "tcp"
    self             = true
    from_port        = 2049
    to_port          = 2049
  }
  ingress {
    description      = "SSH from bastion"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups  = [aws_security_group.bastion_sg.id]
  }
  egress {
   description      = "allow all traffic"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   cidr_blocks      = ["0.0.0.0/0"]
  }
}
