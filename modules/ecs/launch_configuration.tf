data "template_file" "ecs_user_data" {
  template = "${file("${path.module}/templates/ecs-userdata.tpl")}"

  vars {
    cluster_name = "${var.ecs_cluster_name}"
  }
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix   = "${var.environment}_${var.ecs_cluster_name}"
  image_id      = "${var.image_id}"
  instance_type = "${var.instance_type}"

  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.id}"
  security_groups      = ["${aws_security_group.default_all.id}"]              # should be another sg?

  user_data = "${data.template_file.ecs_user_data.rendered}"

  key_name = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "standard"
    volume_size           = 10
    delete_on_termination = true
  }
}

resource "aws_autoscaling_group" "ecs_autoscalling_group" {
  name_prefix          = "${var.environment}"
  max_size             = "${var.autoscaling_max_size}"
  min_size             = "${var.autoscaling_min_size}"
  desired_capacity     = "${var.desired_instance_count}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.ecs_launch_configuration.id}"
  health_check_type    = "ELB"
}
