output "vpc_id" {
  value       = module.my_vpc.vpc_id
  description = "VPCID"
}

output "azs" {
  value       = module.my_vpc.azs
  description = "AvailabilityZone (List)"
}

output "public_subnets" {
  value       = module.my_vpc.public_subnets
  description = "Public Subnets (List)"
}

output "private_subnets" {
  value       = module.my_vpc.private_subnets
  description = "Private Subnets (List)"
}

output "database_subnets" {
  value       = module.my_vpc.database_subnets
  description = "Database Subnets (List)"
}

output "database_subnet_group_name" {
  value       = module.my_vpc.database_subnet_group_name
  description = "Database Subnet Group Name"
}

output "ssh_sg_id" {
  value       = module.SSH_security_group.security_group_id
  description = "SSH Security Group ID"
}

output "alb_sg_id" {
  value       = module.ALB_security_group.security_group_id
  description = "ALB Security Group ID"
}

output "rds_sg_id" {
  value       = module.RDS_SG.security_group_id
  description = "DB Security Group ID"
}

output "EC2_Pub_IP" {
  value       = module.bastion_host.EC2_Pub_IP
  description = "EC2 Instance Public IP Address"
}

output "tg_arn" {
  value       = module.alb.tg_arn
  description = "LB Target Group ARN"
}

output "alb_dns" {
  value       = module.alb.ALB_DNS
  description = "Load Balancer Domain Name"
}