/*
  ECR Resgistry
*/
resource "aws_ecr_repository" "ecr_registry" {
  name = "${var.ecr_name}"
}

/*
  ECS Cluster
*/
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecs_cluster_name}"
}

/*
  Cloudwatch LogGroup
*/

resource "aws_cloudwatch_log_group" "log-group" {
  name = "${var.ecs_cluster_name}-logs"

  tags {
    Application = "${var.ecs_cluster_name}"
    environment = "${var.environment}"
    Name        = "${var.ecs_cluster_name}-logs"
  }
}
