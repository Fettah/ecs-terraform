resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "${var.environment}-rds-subnet-group"
  description = "rds subnet group"
  subnet_ids  = ["${var.subnet_ids}"]

  tags {
    environment = "${var.environment}"
  }
}

# TODO! check what is this for
resource "aws_security_group" "db_access_sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.environment}-db-access-sg"

  tags {
    Name        = "${var.environment}-db-access-sg"
    environment = "${var.environment}"
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.environment}-rds-sg"
  vpc_id = "${var.vpc_id}"

  tags {
    environment = "${var.environment}"
    name        = "${var.environment}-rds-sg"
  }

  # allow traffoc from SG to itself
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    self      = true
  }

  # allow tcp:5432
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = ["${aws_security_group.db_access_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds" {
  name                   = "${var.database_name}"
  username               = "${var.database_username}"
  password               = "${var.database_password}"
  identifier             = "${var.environment}-database"
  allocated_storage      = "${var.allocated_storage}"
  engine                 = "postgres"
  engine_version         = "9.6.6"
  multi_az               = "${var.multi_az}"
  instance_class         = "${var.instance_class}"
  db_subnet_group_name   = "${aws_db_subnet_group.rds_subnet_group.id}"
  vpc_security_group_ids = ["${aws_security_group.rds_sg.id}"]
  skip_final_snapshot    = true

  # snapshot_identifier    = "rds-${var.environment}-snapshot"
}
