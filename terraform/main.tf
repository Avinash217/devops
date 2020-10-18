/**
 * VPC
 */

provider "aws" {
access_key = "AKIAT6XMA3K3ENNNGDAM"
secret_key = "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"
region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    "Name"        = "${var.environment}-${var.vpc_name}"
    "Environment" = "${var.environment}"
    "ManagedBy"   = "CloudCover"
  }
}

/**
 * Gateways
 */

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment}-${var.vpc_name}-gw"
    Environment = "${var.environment}"
  }
}

resource "aws_eip" "nat-ip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.main"]
  vpc        = true
}


resource "aws_nat_gateway" "main" {
  count = "${length(var.internal_subnets) > 0 ? length(var.internal_subnets) : 0}"
  allocation_id = "${aws_eip.nat-ip.id}"
  subnet_id     = "${element(aws_subnet.external.*.id, 1)}"
  depends_on    = ["aws_internet_gateway.main", "aws_subnet.external"]

  tags {
    Name = "${var.environment}-${var.vpc_name}-nat-gw"
  }
}
/**
 * Subnets.
 */

resource "aws_subnet" "internal" {
  count = "${length(var.internal_subnets) > 0 ? length(var.internal_subnets) : 0}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.internal_subnets[count.index], "cidr")}"
  availability_zone = "${lookup(var.internal_subnets[count.index], "az")}"

  tags {
    Name        = "${var.environment}-${var.vpc_name}-${lookup(var.internal_subnets[count.index], "name")}-subnet"
    Environment = "${var.environment}"
  }
}



resource "aws_subnet" "external" {
  count = "${length(var.external_subnets) > 0 ? length(var.external_subnets) : 0}"
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${lookup(var.external_subnets[count.index], "cidr")}"
  availability_zone = "${lookup(var.external_subnets[count.index], "az")}"

  tags {
    Name        = "${var.environment}-${var.vpc_name}-${lookup(var.external_subnets[count.index], "name")}-subnet"
    Environment = "${var.environment}"
  }
}

/**
 * Route tables
 */

resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name        = "${var.vpc_name}-external-rt"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "external" {
  route_table_id         = "${aws_route_table.external.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table" "internal" {
  vpc_id = "${aws_vpc.main.id}"
  tags {
    Name        = "${var.vpc_name}-internal-rt"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "internal" {
  # Create this only if using the NAT gateway service, vs. NAT instances.
  count = "${length(var.internal_subnets) > 0 ? length(var.internal_subnets) : 0}"
  route_table_id         = "${aws_route_table.internal.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.main.id}"
}

/**
 * Route associations
 */
resource "aws_route_table_association" "internal" {
  count = "${length(var.internal_subnets) > 0 ? length(var.internal_subnets) : 0}"
  count          = "${length(var.internal_subnets)}"
  subnet_id      = "${element(aws_subnet.internal.*.id, count.index)}"
  route_table_id = "${aws_route_table.internal.id}"
  depends_on = ["aws_subnet.internal"]
}

resource "aws_route_table_association" "external" {
  count = "${length(var.external_subnets) > 0 ? length(var.external_subnets) : 0}"
  count          = "${length(var.external_subnets)}"
  subnet_id      = "${element(aws_subnet.external.*.id, count.index)}"
  route_table_id = "${aws_route_table.external.id}"
  depends_on = ["aws_subnet.external"]
}

