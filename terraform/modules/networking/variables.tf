variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "azs" {
  type = list(string)
}