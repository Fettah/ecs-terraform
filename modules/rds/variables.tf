variable "environment" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "vpc_id" {
  type        = "string"
  description = "vpc id where rds instance is to be launched in"
}

variable "database_name" {
  type = "string"
}

variable "database_username" {
  type = "string"
}

variable "database_password" {
  type = "string"
}

variable "allocated_storage" {
  type = "string"
}

variable "multi_az" {
  type    = "string"
  default = "false"
}

variable "instance_class" {
  type    = "string"
  default = "db.t2.micro"
}
