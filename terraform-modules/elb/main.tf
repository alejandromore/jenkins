resource "huaweicloud_elb_loadbalancer" "this" {
  name                  = var.name
  vip_subnet_id         = var.subnet_id
  type                  = var.type
  description           = var.description

  bandwidth {
    bandwidth_name      = var.bandwidth_name
    share_type          = var.bandwidth_share_type
    size                = var.bandwidth_size
    charge_mode         = var.bandwidth_charge_mode
  }

  enterprise_project_id = var.enterprise_project_id
  tags                  = var.tags
}
