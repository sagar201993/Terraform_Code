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