
#provider "aws" {
#access_key = "AKIAT6XMA3K3ENNNGDAM"
#secret_key = "IPLWygvAM21mskbakoPm0yI1n2JnfgcufEEnSYDD"
#region = "us-east-1"
#}

resource "aws_instance" "example" {
ami = "ami-02354e95b39ca8dec"
instance_type = "t2.micro"
key_name = "Amazon Linux2"
#security_groups = [ "Amazon Linux2-SG" ] 	#add existing security group
#security_groups = [
#        "${aws_security_group.sg.id}"
security_groups = [ 
	"${aws_security_group.terra-vm-SG.name}" 
]

tags = {
Name = "Testing TerrafomNew"
}
}
resource "aws_security_group" "terra-vm-SG" {

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
   description = "terra-vm-SG"  
 }
}


#resource "aws_network_interface_sg_attachment" "sg_attachment" {
 # security_group_id    = "${aws_security_group.terra-vm-SG.id}"
  #network_interface_id = "${aws_instance.example.primary_network_interface_id}"
#}
