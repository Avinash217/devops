

#provider "aws" {
#access_key = "AKIAT6XMA3K3ENNNGDAM"
#secret_key = "IPLWygvAM21mskbakoPm0yI1n2JnfgcufEEnSYDD"
#region = "us-east-1"
#}

resource "aws_instance" "example" {
ami = "ami-02354e95b39ca8dec"
instance_type = "t2.micro"
key_name = "Amazon Linux2"
count = 2
#security_groups = [ "Amazon Linux2-SG" ] 	#add existing security group
#security_groups = [
#        "${aws_security_group.sg.id}"


#subnet_id = "${aws_subnet.TFPublic.name}"
subnet_id = "${aws_subnet.TFPublic.id}"
#subnet_id = "subnet-067ab45325ce7a36d"
#vpc_security_group_ids = [ "${aws_security_group.terra-vm-SG.id}" ]
vpc_security_group_ids = [ "${aws_security_group.Testing_TerrafomNew.id}" ]
associate_public_ip_address = true
#vpc_security_group_ids = ["sg-06b55d72ae47952a6"]

#security_groups = [ 
#	"${aws_security_group.terra-vm-SG.name}" 
#]

tags = {
Name = "Testing TerrafomNew"
}
}
#resource "aws_security_group" "terra-vm-SG" {
resource "aws_security_group" "Testing_TerrafomNew" {
vpc_id = "${aws_vpc.TFmain.id}"

name = "Testing TerrafomNew"
description = "Testing TerrafomNew inbound traffic"

 ingress {
   description = "TLS from VPC"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

ingress {
   description = "TLS from VPC"
   from_port   = 443
   to_port     = 443
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
ingress {
   description = "TLS from VPC"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

 tags = {
   Name = "terra-vm-SG"
   Name = "testing_terrafomnew"
   description = "terra-vm-SG"  
 }
}


#resource "aws_network_interface_sg_attachment" "sg_attachment" {
 # security_group_id    = "${aws_security_group.terra-vm-SG.id}"
  #network_interface_id = "${aws_instance.example.primary_network_interface_id}"
#}
