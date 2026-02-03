resource "huaweicloud_networking_secgroup" "sg" {
  name                  = var.sg_name
  description           = var.description
  enterprise_project_id = var.enterprise_project_id
}

# ---------------------------
# Ingress Rules (Entrantes)
# ---------------------------
resource "huaweicloud_networking_secgroup_rule" "ingress" {
  for_each = {
    for idx, rule in var.ingress_rules :
    idx => rule
  }

  direction       = "ingress"
  ethertype       = "IPv4"
  protocol        = each.value.protocol
  ports           = each.value.port
  remote_ip_prefix = each.value.remote_ip
  security_group_id = huaweicloud_networking_secgroup.sg.id
}

# ---------------------------
# Egress Rules (Salientes)
# ---------------------------
resource "huaweicloud_networking_secgroup_rule" "egress" {
  for_each = {
    for idx, rule in var.egress_rules :
    idx => rule
  }

  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = each.value.protocol
  ports             = each.value.port
  remote_ip_prefix  = each.value.remote_ip
  security_group_id = huaweicloud_networking_secgroup.sg.id
}
