variable "asg_ami" {
  description = "ASG AMI"
  type = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}
# Instance Type

variable "min_size" {
  description = "ASG Min Size"
  type        = string
}
# Instance 최소 용량

variable "max_size" {
  description = "ASG Max Size"
  type        = string
}

variable "ssh_sg_id" {
  description = "ssh_sg_id"
  type = string
}

variable "alb_sg_id" {
  description = "alb_sg_id"
  type = string
}

variable "vpc_id" {
  description = "VPC Module ID"
  type = string
}

variable "private_subnet1" {
  description = "Private-1 ID"
  type = string
}

variable "private_subnet2" {
  description = "Private-2 ID"
  type = string
}

variable "lb_tg_arn" {
  description = "LoadBalancer Target Group ARN"
  type = string
}