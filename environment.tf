# TODO! add backend.tf
# terraform {
#   required_version = ">= 0.8"
# }

provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

resource "aws_key_pair" "key" {
  key_name   = "${var.private_key_name}"
  public_key = "${var.public_key}"
}

module "networking" {
  source                = "./modules/networking"
  environment           = "terraform"
  vpc_cidr              = "10.0.0.0/16"                      # Todo! move to variables
  public_subnets_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones    = ["eu-central-1a", "eu-central-1b"]
  key_name              = "${aws_key_pair.key.key_name}"
  region                = "${var.region}"
}

module "ecs" {
  source      = "./modules/ecs"
  vpc_id      = "${module.networking.vpc_id}"
  subnet_ids  = ["${module.networking.public_subnets_ids}"]
  region      = "${var.region}"
  key_name    = "${aws_key_pair.key.key_name}"
  environment = "terraform"

  instance_type = "t2.micro"
  image_id      = "ami-c7e9e72c"

  desired_task_count = 1
  ecs_cluster_name   = "my-cluster-1"
  ecr_name           = "my-ecr-1"
  container_port     = 80
  alb_port           = 80

  # main container name
  container_name = "nginx"
  task_file_name = "nginx_task_definition.json"

  autoscaling_max_size   = 1
  autoscaling_min_size   = 1
  desired_instance_count = 1
}

# module "rds" {
#   source            = "./modules/rds"
#   environment       = "${var.environment}"
#   subnet_ids        = ["${module.networking.private_subnets_ids}"] # form the output in networking
#   allocated_storage = 10
#   database_name     = "${var.terraform_database_name}"
#   database_password = "${var.terraform_database_password}"
#   database_username = "${var.terraform_database_username}"
#   vpc_id            = "${module.networking.vpc_id}"
#   instance_class    = "db.t2.micro"
# }

