resource "huaweicloud_rds_instance" "this" {
  name                  = var.name
  flavor                = var.flavor
  availability_zone     = var.availability_zone
  vpc_id                = var.vpc_id
  subnet_id             = var.subnet_id
  security_group_id     = var.security_group_id
  enterprise_project_id = var.enterprise_project_id

  # Engine
  db {
    type        = var.engine_type
    version     = var.engine_version
    password    = var.db_password
    port        = var.port
  }

  # Storage
  volume {
    type = var.volume_type
    size = var.volume_size
  }

  # Backup policy (best practice)
  backup_strategy {
    start_time = var.backup_start_time
    keep_days  = var.backup_keep_days
  }

  tags = var.tags
}