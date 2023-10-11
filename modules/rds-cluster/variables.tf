variable "engine" {
  description = "RDS Engine"
  type = string
}

variable "engine_ver" {
  description = "RDS Engine Version"
  type = string
}

variable "engine_mode" {
  description = "RDS Engine Mode"
  type = string
}

variable "cluster_identifier" {
  description = "Cluster Identifier"
  type = string
}

variable "db_instance_class" {
  description = "Database Cluster Instance class"
}

variable "db_name" {
  description = "Database Name"
  type = string
}

variable "db_azs" {
  description = "Database Availability zones"
  type = list
}

variable "db_subnet_group_name" {
  description = "Database Subnet Group Name"
  type = string
}

variable "rds_sg_id" {
  description = "Database Security Group ID"
  type = string
}

variable "master_username" {
  description = "RDS Master User Name"
  type = string
}

variable "master_password" {
  description = "RDS Master User Password"
  type = string
}

variable "cluster_instance_count" {
  description = "RDS Cluster Instance Count"
  type = number
}