
# create a VPC

resource "aws_vpc" "dev_local" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "dev_vpc"
    }
  
}

# create subnets
    #select VPC and give subnet name and cidr block

resource "aws_subnet" "dev_local" {
  vpc_id = aws_vpc.dev_local.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "dev_subnet"
  }
}

# create Internet gateway and attach to vpc

resource "aws_internet_gateway" "dev_local" {
  
  vpc_id = aws_vpc.dev_local.id

}

#create route table and associate routes

resource "aws_route_table" "dev_local" {
  
  vpc_id = aws_vpc.dev_local.id

  route {

    cidr_block = "0.0.0.0/24"
    gateway_id = aws_internet_gateway.dev_local.id
  }
}

#subnet association

resource "aws_route_table_association" "dev_local" {
  
  subnet_id = aws_subnet.dev_local.id
  route_table_id = aws_route_table.dev_local.id
}

# create security group

resource "aws_security_group" "dev_local" {

name = "allow_tls"
vpc_id = aws_vpc.dev_local.id

tags = {
  Name = "dev_sg"
}
ingress {
    description = "Inbound rules"
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]

}
ingress {
    description = "Inbound rules"
     from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

}
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
     cidr_blocks = ["0.0.0.0/0"]

}
}

#create S3 bucket
resource "aws_s3_bucket" "dev_local" {
    bucket = "devlocalbucketnag19112024tfstateversioning"
  
}
#create EC2
