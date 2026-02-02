# Subnet
resource "huaweicloud_vpc_subnet" "this" {
  vpc_id             = var.vpc_id
  name               = var.subnet_name
  cidr               = var.cidr
  gateway_ip         = var.gateway_ip
  description        = var.description
  dns_list           = var.dns_list
  dhcp_enable        = var.dhcp_enable
  availability_zone  = var.availability_zone
  tags               = var.tags
}
