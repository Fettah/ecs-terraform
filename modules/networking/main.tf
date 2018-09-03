resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name        = "${var.environment}-vpc"
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-ig"
    environment = "${var.environment}"
  }
}

resource "aws_eip" "eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.ig"]

  tags {
    Name        = "${var.environment}-eip"
    environment = "${var.environment}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"
  depends_on    = ["aws_internet_gateway.ig"]

  tags {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-nat"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.public_subnets_cidrs)}"
  cidr_block              = "${element(var.public_subnets_cidrs, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-public"
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${length(var.private_subnets_cidrs)}"
  cidr_block              = "${element(var.private_subnets_cidrs, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "${var.environment}-${element(var.availability_zones, count.index)}-private"
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.ig.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

# route tables association
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_cidrs)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_cidrs)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_rt.id}"
}
