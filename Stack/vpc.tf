#Providers

#provider "aws" {
#  region     = "us-east-1"
#  access_key = "AKIAT6XMA3K3ENNNGDAM"
#  secret_key = "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"
#}

#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.TFmain.id}"

  tags = {
    Name = "TFmain"
  }
}
#VPC
resource "aws_vpc" "TFmain" {
  cidr_block       = "11.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "TFmain"
  }
}

#Public Subnet

resource "aws_subnet" "TFPublic" {
  vpc_id     = "${aws_vpc.TFmain.id}"
  cidr_block = "11.0.1.0/24"

  tags = {
    Name = "TFPublic"
  }
}

#Private Subnet

resource "aws_subnet" "TFPrivate" {
  vpc_id     = "${aws_vpc.TFmain.id}"
  cidr_block = "11.0.2.0/24"

  tags = {
    Name = "TFPrivate"
  }
}

#Subnet Association
resource "aws_route_table_association" "a" {
  subnet_id      = "${aws_subnet.TFPublic.id}"
  route_table_id = "${aws_route_table.TFPublicRTB.id}"
}

#PublicRTB

resource "aws_route_table" "TFPublicRTB" {
  vpc_id = "${aws_vpc.TFmain.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }		

  tags = {
    Name = "TFPublicRTB"
  }
}

#Subnet Association
resource "aws_route_table_association" "b" {
  subnet_id	 = "${aws_subnet.TFPrivate.id}"
  route_table_id = "${aws_route_table.TFPrivateRTB.id}"
}

#resource "aws_nat_gateway" "Myngw" {
 # subnet_id     = aws_subnet.TFPublic.id
  #allocation_id = aws_eip.MyEip.id
  #tags = {
   #Name = "Myngw"
  #}
#}

#resource "aws_eip" "MyEip" {
 # vpc                       = true
  #tags = {
   #     Name = "MyEip"
  #}
#}

#resource "aws_route_table" "TFPrivateRTB" {
#  vpc_id = "${aws_vpc.TFmain.id}"
#  tags = {
#        Name = "TFPrivateRTB"
 # }
  #route {
   # cidr_block = "0.0.0.0/0"
    #gateway_id = aws_nat_gateway.Myngw.id
  #}
#}

#PrivateRTB

resource "aws_route_table" "TFPrivateRTB" {
  vpc_id = "${aws_vpc.TFmain.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "TFPrivateRTB"
  }
}
