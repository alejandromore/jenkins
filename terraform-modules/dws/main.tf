resource "huaweicloud_dws_cluster" "this" {
  name              = var.dws_name
  node_type         = var.node_type
  number_of_node    = var.number_of_nodes
  number_of_cn      = var.number_of_cn
  availability_zone = var.availability_zone
  enterprise_project_id = var.enterprise_project_id

  user_name         = var.db_username
  user_pwd          = var.db_password

  vpc_id            = var.vpc_id
  network_id        = var.subnet_id
  security_group_id = var.security_group_id

  volume {
    type            = var.volume_type
    capacity        = var.volume_capacity
  }

  tags              = var.tags
}