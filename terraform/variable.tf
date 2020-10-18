variable "vpc_name" {
  description = "The CIDR block for the VPC."
  default = "test"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default = "192.168.0.0/24"
}

variable "external_subnets" {
  description = "List of external subnets"
  type        = "list"
  default = []
}

variable "internal_subnets" {
  description = "List of internal subnets"
  type        = "list"
  default = []
}

variable "environment" {
  description = "Environment tag, e.g prod"
  default = "prod"
}
