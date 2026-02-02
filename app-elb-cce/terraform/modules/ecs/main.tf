# ECS Instance
locals {
  # Validación: solo uno de estos debe estar definido
  use_keypair  = var.keypair_name != null && var.keypair_name != ""
  use_password = var.ecs_password != null && var.ecs_password != ""

  invalid_combo = local.use_keypair && local.use_password
  invalid_empty = !local.use_keypair && !local.use_password
}

# Validación — evita combinaciones no permitidas
resource "null_resource" "validation" {
  count = local.invalid_combo ? 1 : local.invalid_empty ? 1 : 0

  provisioner "local-exec" {
    command = "echo '❌ ERROR: You must set ONLY ONE of: keypair_name OR ecs_password.' && exit 1"
  }
}

resource "huaweicloud_compute_instance" "ecs" {
  name                  = var.ecs_name
  availability_zone     = var.availability_zone
  flavor_id             = var.flavor_id
  image_id              = var.image_id

  admin_pass = local.use_password ? var.ecs_password : null

  key_pair = local.use_keypair ? var.keypair_name : null

  security_group_ids    = [var.security_group_id]
  enterprise_project_id = var.enterprise_project_id

  network {
    uuid = var.subnet_id
  }

  system_disk_type = var.root_volume_type
  system_disk_size = var.root_volume_size

  agency_name           = var.agency_name

  tags = var.tags
}
