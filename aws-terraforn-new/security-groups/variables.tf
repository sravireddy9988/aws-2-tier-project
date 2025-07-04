variable "ec2_sg_name" {
  type        = string
  description = "Name for EC2 security group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "public_subnet_cidr_block" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
}
