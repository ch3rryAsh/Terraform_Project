variable "vpc_id" {
  description = "VPC Module ID"
  type = string
}

variable "public_subnet1" {
  description = "Public-1 ID"
  type = string
}

variable "public_subnet2" {
  description = "Public-2 ID"
  type = string
}

variable "alb_sg_id" {
  description = "alb_sg_id"
  type = string
}