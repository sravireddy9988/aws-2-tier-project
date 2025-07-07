variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cidr_public_subnet" {
  type = list(string)
}

variable "eu_availability_zone" {
  type = list(string)
}
