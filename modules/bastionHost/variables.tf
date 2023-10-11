variable "bastion_availability_zone" {
  description = "Bastion Host AZ"
  type        = string
}

variable "bastion_subnet_id" {
  description = "Bastion Host Subnet ID"
  type        = string
}

variable "ssh_sg_id" {
  description = "ssh_sg_id"
  type        = string
}

variable "ami" {
  description = "ami"
  type        = string
}

variable "bastionHost_instance_type" {
  description = "Bastion Host Instance Type"
  type        = string
}