#######################################
# ELB
#######################################
resource "huaweicloud_lb_loadbalancer" "elb_public" {
  name          = "elb-public"
  vip_subnet_id = huaweicloud_vpc_subnet.vpc_subnet_cce.ipv4_subnet_id
  security_group_ids = [huaweicloud_networking_secgroup.sg_elb.id]
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# ELB EIP
#######################################
resource "huaweicloud_vpc_eip" "eip_elb" {
  name = var.eip_elb_name
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type = "WHOLE"
    id = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# Associate EIP to ELB
#######################################
resource "huaweicloud_vpc_eip_associate" "eip_1" {
  public_ip = huaweicloud_vpc_eip.eip_elb.address
  port_id   = huaweicloud_lb_loadbalancer.elb_public.vip_port_id
}

#######################################
# NAT Gateway EIP
#######################################
resource "huaweicloud_vpc_eip" "eip_ng" {
  name = var.eip_ng_name
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type = "WHOLE"
    id = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# NAT Gateway
#######################################
resource "huaweicloud_nat_gateway" "cce_nat_gateway" {
  name        = var.ng_name
  vpc_id      = huaweicloud_vpc.vpc_service.id
  subnet_id   = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  spec        = var.ng_spec
  description = var.ng_description
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# SNAT rule for worker nodes
#######################################
resource "huaweicloud_nat_snat_rule" "this" {
  count = 1
  nat_gateway_id = huaweicloud_nat_gateway.cce_nat_gateway.id
  subnet_id      = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  floating_ip_id = huaweicloud_vpc_eip.eip_ng.id
  description    = "SNAT rule for CCE subnet internet access"
}

#######################################
# CCE Cluster EIP
#######################################
resource "huaweicloud_vpc_eip" "eip_cce" {
  name = var.eip_cce_name
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    share_type = "WHOLE"
    id = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

#######################################
# CCE Cluster
#######################################
resource "huaweicloud_cce_cluster" "cce_cluster_standard" {
  name                   = var.cce_cluster_name
  alias                  = var.cce_cluster_name
  region                 = var.region
  flavor_id              = var.cce_cluster_flavor
  cluster_type           = var.cce_cluster_type
  cluster_version        = var.cce_k8s_version
  authentication_mode    = var.cce_authentication_mode
  charging_mode          = var.cce_charging_mode
  vpc_id                 = huaweicloud_vpc.vpc_service.id
  subnet_id              = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  container_network_type = var.cce_network_type
  service_network_cidr   = var.cce_network_cidr
  security_group_id      = huaweicloud_networking_secgroup.sg_cce.id
  eip                    = huaweicloud_vpc_eip.eip_cce.address
  kube_proxy_mode        = "iptables"
  enable_distribute_management = false
  ipv6_enable            = false
  enterprise_project_id  = data.huaweicloud_enterprise_project.ep.id
  timezone               = "America/Lima"
  tags                   = var.tags
  masters {
    availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  }
}

#######################################
# Node Pool
#######################################
data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0] 
  performance_type  = "computingv3" 
  generation        = "c7" 
  cpu_core_count    = 4 
  memory_size       = 8 
} 

resource "huaweicloud_cce_node_pool" "nodepool" {
  cluster_id         = huaweicloud_cce_cluster.cce_cluster_standard.id
  name               = "cce-nodepool-public"
  initial_node_count = 1
  subnet_id          = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  flavor_id          = data.huaweicloud_compute_flavors.myflavor.flavors[0].id
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  os                 = "EulerOS 2.9"
  scall_enable             = true
  min_node_count           = 4
  max_node_count           = 50
  scale_down_cooldown_time = 100
  priority                 = 1
  type                     = "vm"
  root_volume {
    size       = 40
    volumetype = "SAS"
  }
  data_volumes {
    size       = 100
    volumetype = "SAS"
  }
  security_groups    = [huaweicloud_networking_secgroup.sg_cce.id]
  key_pair           = var.key_pair_name
  tags = var.tags
}
