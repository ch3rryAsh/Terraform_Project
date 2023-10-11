resource "aws_rds_cluster" "my_rds_cluster" {
  cluster_identifier = var.cluster_identifier
  engine = var.engine
  engine_version = var.engine_ver
  engine_mode        = var.engine_mode

  database_name = var.db_name
  availability_zones = var.db_azs
  db_subnet_group_name = var.db_subnet_group_name
  vpc_security_group_ids = [var.rds_sg_id]
  master_username = var.master_username
  master_password = var.master_password
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = var.cluster_instance_count
  identifier         = "aurora-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.my_rds_cluster.id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.my_rds_cluster.engine
  engine_version     = aws_rds_cluster.my_rds_cluster.engine_version
}