

resource "aws_instance" "demo-server" {
  ami = "ami-04e5276ebb8451442"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.demo_subnet.id
  vpc_security_group_ids = [aws_security_group.demo_vpc_sg.id]
}

// create VPC 
resource "aws_vpc" "demo_vpc" {
  cidr_block = "10.10.0.0/16"
}

// create Subnet
resource "aws_subnet" "demo_subnet" {
  vpc_id = aws_vpc.demo_vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "demo-subnet"
  }
}

//create internet gateway
resource "aws_internet_gateway" "demo_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-vpc"
  }
}

//create route table 

resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.demo_igw.id
  }
  tags = {
    Name = "demo-rt"
  }
}

//create route table assoc
resource "aws_route_table_association" "demo_rt_association" {
  subnet_id      = aws_subnet.demo_subnet.id
  route_table_id = aws_route_table.demo_rt.id

}


//create security group 
resource "aws_security_group" "demo_vpc_sg" {
  name        = "demo_vpc_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress{
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
