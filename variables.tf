variable "project_name" {
  default = "ror-app"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "db_username" {}
variable "db_password" {}
variable "db_host" {}

variable "vpc_id" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}

variable "ecr_repo_url" {}



























