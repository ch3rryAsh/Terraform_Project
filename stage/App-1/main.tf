terraform {
  backend "s3" {
    bucket         = "myterraform-bucket-state-ash-t3"
    region         = "ap-northeast-2"
    profile        = "terraform_user"
    dynamodb_table = "myTerraform-bucket-lock-ash-t3"
    encrypt        = true
    key            = "stage/tfstate.tf"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "terraform_user"
}

/* ==================== */

# VPC Module

module "my_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"
  name    = "my_vpc"
  cidr    = local.stage_cidr

  azs              = local.azs
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  enable_dns_support     = "true"
  enable_dns_hostnames   = "true"
  enable_nat_gateway     = "true" // NAT Gateway 생성
  single_nat_gateway     = "true" // NAT Gateway 하나만 -> 어느 Public Subnet에 만들어지는지? -> 알아서 a에 만들어짐
  one_nat_gateway_per_az = false  // NAT Gateway 하나만

  create_database_subnet_route_table = "true"

  tags = {
    "TerraformManaged" = true
  }
}


# Security Group Module

module "SSH_security_group" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "SSH_SG"
  description     = "SSH Port Open"
  vpc_id          = module.my_vpc.vpc_id
  use_name_prefix = "false"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "SSH Port"
      cidr_blocks = local.all_network
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

module "ALB_security_group" {
  source          = "terraform-aws-modules/security-group/aws"
  version         = "5.1.0"
  name            = "ALB_SG"
  description     = "HTTP, HTTPS Port Open"
  vpc_id          = module.my_vpc.vpc_id
  use_name_prefix = "false"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "HTTP Port"
      cidr_blocks = local.all_network
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "HTTPS Port"
      cidr_blocks = local.all_network
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = local.any_port
      to_port     = local.any_port
      protocol    = local.any_protocol
      cidr_blocks = local.all_network
    }
  ]
}

module "RDS_SG" {
  source          = "terraform-aws-modules/security-group/aws"
  name            = "RDS_SG"
  description     = "DB Port Allow"
  vpc_id          = module.my_vpc.vpc_id
  use_name_prefix = "false"

  ingress_with_cidr_blocks = [
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = local.tcp_protocol
      description = "DB Port"
      cidr_blocks = local.private_subnets[0]
    },
    {
      from_port   = local.db_port
      to_port     = local.db_port
      protocol    = local.tcp_protocol
      description = "DB Port"
      cidr_blocks = local.private_subnets[1]
    }
  ]
}


# Bastion Host

module "bastion_host" {
  source                    = "../../modules/bastionHost"
  ami                       = "ami-0ea4d4b8dc1e46212"
  bastionHost_instance_type = "t2.micro"
  bastion_availability_zone = data.terraform_remote_state.remote_data.outputs.azs[1]
  bastion_subnet_id         = data.terraform_remote_state.remote_data.outputs.public_subnets[1]
  ssh_sg_id                 = data.terraform_remote_state.remote_data.outputs.ssh_sg_id

  depends_on = [module.my_vpc, module.SSH_security_group]
}


# ALB

module "alb" {
  source         = "../../modules/lb"
  vpc_id         = data.terraform_remote_state.remote_data.outputs.vpc_id
  public_subnet1 = data.terraform_remote_state.remote_data.outputs.public_subnets[0]
  public_subnet2 = data.terraform_remote_state.remote_data.outputs.public_subnets[1]
  alb_sg_id      = data.terraform_remote_state.remote_data.outputs.alb_sg_id
}


# ASG

module "ASG" {
  source          = "../../modules/web-cluster"
  asg_ami         = "ami-0ea4d4b8dc1e46212"
  instance_type   = "t2.micro"
  max_size        = 2
  min_size        = 2
  ssh_sg_id       = data.terraform_remote_state.remote_data.outputs.ssh_sg_id
  alb_sg_id       = data.terraform_remote_state.remote_data.outputs.alb_sg_id
  lb_tg_arn       = data.terraform_remote_state.remote_data.outputs.tg_arn
  vpc_id          = data.terraform_remote_state.remote_data.outputs.vpc_id
  private_subnet1 = data.terraform_remote_state.remote_data.outputs.private_subnets[0]
  private_subnet2 = data.terraform_remote_state.remote_data.outputs.private_subnets[1]
  depends_on      = [module.alb]
}


# RDS

module "RDS" {
  source                 = "../../modules/rds-cluster"
  db_azs                 = data.terraform_remote_state.remote_data.outputs.azs
  rds_sg_id              = data.terraform_remote_state.remote_data.outputs.rds_sg_id
  engine                 = "aurora-mysql"
  engine_ver             = "5.7.mysql_aurora.2.12.0"
  engine_mode            = "provisioned"
  db_instance_class      = "db.t3.small"
  db_name                = "my-db"
  db_subnet_group_name   = data.terraform_remote_state.remote_data.outputs.database_subnet_group_name
  master_username        = "admin"
  master_password        = "ITbank3#"
  cluster_instance_count = 2
  cluster_identifier     = "app1-db"
}
