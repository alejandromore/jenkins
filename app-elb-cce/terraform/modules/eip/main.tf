resource "huaweicloud_vpc_eip" "this" {
  name         = var.eip_name
  publicip {
    type = "5_bgp" # Dynamic BGP (tipo de EIP)
  }

  bandwidth {
    name        = var.bandwidth_name
    size        = 300       # 300 Mbit/s
    share_type  = "PER"
    charge_mode = "traffic"
  }
  charging_mode = "postPaid"    # Post-pago (pay-per-use)
  enterprise_project_id = var.enterprise_project_id
  tags = var.tags
}
