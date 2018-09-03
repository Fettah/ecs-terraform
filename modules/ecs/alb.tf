/*
  ALB and related resources (target group, alb Listener)
*/

resource "aws_alb" "alb" {
  name            = "${var.ecs_cluster_name}-${var.environment}-alb"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${aws_security_group.default_all.id}"]

  tags {
    environment = "${var.environment}"
    Name        = "${var.ecs_cluster_name}-${var.environment}-alb"
  }
}

resource "aws_alb_target_group" "target_group" {
  name     = "${var.ecs_cluster_name}-alb-tg"
  port     = "${var.container_port}"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    environment = "${var.environment}"
    Name        = "${var.environment}-${var.ecs_cluster_name}-tg"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${var.alb_port}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type             = "forward"
  }
}
