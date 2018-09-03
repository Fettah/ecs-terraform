resource "aws_security_group" "default_all" {
  name_prefix = "${var.environment}-default-all"
  vpc_id      = "${var.vpc_id}"
  description = "open all protocols and ports"

  tags {
    environment = "${var.environment}"
    Name        = "${var.environment}-default-all"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
