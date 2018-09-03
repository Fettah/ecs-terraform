variable "region" {
  default = "eu-central-1"
}

variable "environment" {
  type    = "string"
  default = "terraform"
}

variable "terraform_database_name" {
  type = "string"
}

variable "terraform_database_username" {
  type = "string"
}

variable "terraform_database_password" {
  type = "string"
}

variable "public_key" {
  type = "string"
}

variable "private_key_name" {
  type = "string"
}

variable "access_key" {
  type = "string"
}

variable "secret_key" {
  type = "string"
}
