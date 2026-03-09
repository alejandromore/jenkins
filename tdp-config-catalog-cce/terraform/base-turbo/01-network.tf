#######################################
# VPC
#######################################
resource "huaweicloud_vpc" "vpc_service" {
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  region = var.region

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# Subnets
#######################################
resource "huaweicloud_vpc_subnet" "vpc_subnet_cce" {
  vpc_id             = huaweicloud_vpc.vpc_service.id
  name               = var.vpc_subnet_cce_name
  cidr               = var.vpc_subnet_cce_cidr
  gateway_ip         = var.vpc_subnet_cce_gateway_ip
  description        = "VPC Subnet CCE"
  dns_list           = var.dns_list
  dhcp_enable        = true
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  tags               = var.tags
}

resource "huaweicloud_vpc_subnet" "vpc_subnet_cce_eni" {
  vpc_id             = huaweicloud_vpc.vpc_service.id
  name               = var.vpc_subnet_cce_eni_name
  cidr               = var.vpc_subnet_cce_eni_cidr
  gateway_ip         = var.vpc_subnet_cce_eni_gateway_ip
  description        = "VPC Subnet CCE ENI"
  dns_list           = var.dns_list
  dhcp_enable        = true
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  tags               = var.tags
}

#######################################
# Shared Bandwidth
#######################################
resource "huaweicloud_vpc_bandwidth" "bandwidth_shared" {
  name = var.bandwidth_name
  size = var.bandwidth_size
}