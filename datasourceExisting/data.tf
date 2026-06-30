data "aws_vpc" "dev_vpc" {
  tags = {
    Name = "dev-vpc"
  }
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["dev-public-subnet"]
  }

  vpc_id = data.aws_vpc.dev_vpc.id
}

data "aws_security_group" "web_sg" {
  filter {
    name   = "group-name"
    values = ["dev-web-sg"]
  }

  vpc_id = data.aws_vpc.dev_vpc.id
}