resource "aws_db_instance" "terrafomrds" {
  identifier = "terrafomrds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
 # vpc_security_group_ids   = ["${aws_security_group.mydb1.id}"]
  #subnet_id = "${aws_subnet.TFPrivate.id}"
  #vpc_security_group_ids = [ "${aws_db_security_group.Testing_TerrafomNewRDS.id}" ]
  subnet_id = "${aws_subnet.TFPrivate.id}"
  #subnet_id = "subnet-0911d8aa3f40fcbae"
  vpc_security_group_ids = [ "${aws_security_group.mydb1.id}" ]
tags = {
Name = "terrafomrds"
}
}

resource "aws_security_group" "mydb1" {
  name = "mydb1"

 description = "RDS mysql servers (terraform-managed)"
  vpc_id = "${aws_vpc.TFmain.id}"
  

# Only MYSQL in
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


