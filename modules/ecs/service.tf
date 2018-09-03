/*
  ECS Task Template & Task Definition
*/

data "template_file" "nginx_task_definition" {
  template = "${file("${path.module}/tasks/${var.task_file_name}")}"

  vars {
    image          = "nginx"                                      #"${aws_ecr_repository.ecr_registry.repository_url}" # 440165904984.dkr.ecr.eu-central-1.amazonaws.com/gettings_started_ecr_3
    container_name = "${var.container_name}"
    container_port = "${var.container_port}"
    log_group      = "${aws_cloudwatch_log_group.log-group.name}"
    log_region     = "${var.region}"

    # rds url could be passed here then used as env variable
  }
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                = "${var.ecs_cluster_name}_app"
  container_definitions = "${data.template_file.nginx_task_definition.rendered}"
}

/*
  ECS Service
*/
resource "aws_ecs_service" "ecs_service" {
  name = "${var.ecs_cluster_name}"

  task_definition = "${aws_ecs_task_definition.ecs_task_definition.arn}"
  cluster         = "${aws_ecs_cluster.ecs_cluster.id}"
  launch_type     = "EC2"
  desired_count   = "${var.desired_task_count}"
  iam_role        = "${aws_iam_role.ecs_service_role.name}"

  load_balancer {
    container_name   = "${var.container_name}"
    container_port   = "${var.container_port}"
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
  }

  # depends_on = ["${aws_alb_listener.alb_listener}"]
}
