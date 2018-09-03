variable "environment" {
  default = "terrform"
}

variable "vpc_cidr" {}

variable "public_subnets_cidrs" {
  type = "list"
}

variable "private_subnets_cidrs" {
  type = "list"
}

variable "availability_zones" {
  type = "list"
}

variable "region" {}

variable "key_name" {}
