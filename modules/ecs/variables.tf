variable "ecr_name" {
  type = "string"
}

variable "ecs_cluster_name" {
  type = "string"
}

variable "container_name" {
  type = "string"
}

variable "container_port" {
  type = "string"
}

variable "desired_task_count" {
  type = "string"
}

variable "vpc_id" {
  type = "string"
}

variable "environment" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "alb_port" {
  type = "string"
}

variable "key_name" {}

variable "autoscaling_max_size" {
  type = "string"
}

variable "autoscaling_min_size" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "image_id" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "task_file_name" {
  type = "string"
}

variable "desired_instance_count" {
  type    = "string"
  default = 1
}
