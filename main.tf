
# Create VPC
resource "aws_vpc" "gbadineni" {
  cidr_block = "17.2.0.0/16"

  tags = {
    Name = "gbadineni"
  }
}

# Create Public Subnet
resource "aws_subnet" "gbadineni_public_subnet" {
  vpc_id     = aws_vpc.gbadineni.id
  cidr_block = "17.2.1.0/24"

  tags = {
    Name = "gbadineni_public_subnet"
  }
}

# Create Private Subnet
resource "aws_subnet" "gbadineni_private_subnet" {
  vpc_id     = aws_vpc.gbadineni.id
  cidr_block = "17.2.2.0/24"

  tags = {
    Name = "gbadineni_private_subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gbadineni" {
  vpc_id = aws_vpc.gbadineni.id

  tags = {
    Name = "gbadineni_Internetgateway"
  }
}

# Create Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.gbadineni.id

  tags = {
    Name = "gbadineni_public_routable"
  }
}

# Create Default Route for Public Route Table
resource "aws_route" "gbadineni_public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gbadineni.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.gbadineni_public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create NAT Gateway
resource "aws_nat_gateway" "gbadineni_nat_gateway" {
  allocation_id = aws_eip.gbadineni_eip.id
  subnet_id     = aws_subnet.gbadineni_public_subnet.id

  tags = {
    Name = "gbadineni_natgate"
  }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "gbadineni_eip" {
  vpc = true

  tags = {
    Name = "gbadineni_eip"
  }
}

# Create Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.gbadineni.id

  tags = {
    Name = "gbadineni_private_route"
  }
}

# Create Default Route for Private Route Table pointing to NAT Gateway
resource "aws_route" "gbadineni_private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gbadineni_nat_gateway.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.gbadineni_private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
