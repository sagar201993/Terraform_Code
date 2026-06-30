resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "dev-vpc"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
# create public subnet 

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name        = "dev-public-subnet"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# internet gateway 

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name        = "dev-igw"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
# create route table 
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "dev-public-route-table"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
# Route Table Association.
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# security group
resource "aws_security_group" "web_sg" {
  name        = "dev-web-sg"
  description = "Allow SSH and HTTP access"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "dev-web-sg"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# ec2 instance
resource "aws_instance" "web_server" {
  ami                         = "ami-0cfde0ea8edd312d4"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data_replace_on_change = true

  user_data = <<-EOF
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl enable apache2
systemctl start apache2
echo "<h1>Hello Sagar! Terraform + Apache is Working</h1>" > /var/www/html/index.html
EOF
  tags = {
    Name        = "dev-web-server"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
