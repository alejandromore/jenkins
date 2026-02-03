##############################################
# CCE Cluster
##############################################

resource "huaweicloud_cce_cluster" "this" {
  name                   = var.cce_cluster_name
  cluster_type           = var.cce_cluster_type
  flavor_id              = var.cce_cluster_flavor
  cluster_version        = var.cce_k8s_version

  vpc_id                 = var.cce_vpc_id
  subnet_id              = var.cce_subnet_id
  security_group_id      = var.security_group_id

  container_network_type = var.cce_network_type
  container_network_cidr = var.cce_network_cidr
  authentication_mode    = var.cce_authentication_mode
  eip                    = var.cce_eip
  charging_mode          = var.cce_charging_mode

  masters {
    availability_zone    = var.cce_availability_zone 
  }

  enterprise_project_id  = var.cce_enteprise_project_id

  eni_subnet_id          = var.cce_eni_subnet_id
  eni_subnet_cidr        = var.cce_eni_subnet_cidr

  tags                   = var.tags
}
