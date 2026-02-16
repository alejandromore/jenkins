# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

#######################################
# VPC Module
#######################################
module "vpc" {
  source            = "../../terraform-modules/vpc"
  name              = var.vpc_name
  cidr              = var.vpc_cidr
  project_id        = data.huaweicloud_enterprise_project.ep.id
  tags              = var.tags
  region            = var.region
}

#######################################
# Subnets
#######################################
module "subnet_public" {
  source            = "../../terraform-modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_public_name
  cidr              = var.vpc_subnet_public_cidr
  gateway_ip        = var.vpc_subnet_public_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

module "subnet_cce" {
  source            = "../../terraform-modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_cce_name
  cidr              = var.vpc_subnet_cce_cidr
  gateway_ip        = var.vpc_subnet_cce_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

module "subnet_cce_eni" {
  source            = "../../terraform-modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_cce_eni_name
  cidr              = var.vpc_subnet_cce_eni_cidr
  gateway_ip        = var.vpc_subnet_cce_eni_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

#######################################
# Security Group
#######################################
module "sg_public" {
  source                = "../../terraform-modules/security_group"
  sg_name               = var.security_group_public
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

module "sg_cce_eni" {
  source                = "../../terraform-modules/security_group"
  sg_name               = var.security_group_cce_eni
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

module "sg_cce" {
  source                = "../../terraform-modules/security_group"
  sg_name               = var.security_group_cce
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}


#######################################
# Security Group Rules - Public
#######################################
# Reglas para ELB
resource "huaweicloud_networking_secgroup_rule" "public_ingress_http" {
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ELB (80)"
}
# ELB necesita comunicarse con ECS para tráfico de aplicación
resource "huaweicloud_networking_secgroup_rule" "public_egress_to_private" {
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8081
  port_range_max    = 8081
  remote_group_id   = module.sg_cce.security_group_id
  description       = "ELB → CCE (8081)"
}

# ELB necesita puertos efímeros para health checks y sesiones
resource "huaweicloud_networking_secgroup_rule" "public_egress_ephemeral_health" {
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 32768  # Puertos efímeros típicos de Linux
  port_range_max    = 60999
  remote_group_id   = module.sg_cce.security_group_id
  description       = "ELB → CCE para health check y sesiones"
}

#######################################
# Security Group CCE ENI - Rules 
#######################################
resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_cidr" {
  security_group_id = module.sg_cce_eni.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_cidr
  description       = "Used by worker nodes to access each other and to access the master node."
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_self" {
  security_group_id = module.sg_cce_eni.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = module.sg_cce_eni.security_group_id
  description       = "Traffic from the source IP addresses defined in the security group must be allowed."
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_egress_all" {
  security_group_id = module.sg_cce_eni.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Default egress security group rule for CCE ENI"
}

#######################################
# Security Group CCE Node - Rules 
#######################################
resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_udp" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Default access port range of the NodePort service in the cluster."
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_tcp" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Default access port range of the NodePort service in the cluster."
}

resource "huaweicloud_networking_secgroup_rule" "private_ingress_elb_health_8080" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "ELB Huawei Cloud → ECS (health check 8080)"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_worker_access" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix = var.vpc_subnet_cce_cidr
  description       = "Used by worker nodes to access each other and to access the master node."
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = module.sg_cce.security_group_id
  description       = "Traffic from the source IP addresses defined in the security group must be allowed."
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Default egress security group rule"
}

#######################################
# ELB
#######################################
module "eip_elb_public" {
  source                = "../../terraform-modules/eip"
  eip_name              = "eip-elb-public"
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_lb_loadbalancer" "elb_public" {
  name               = "elb-public"
  vip_subnet_id      = module.subnet_public.ipv4_subnet_id
  security_group_ids = [module.sg_public.security_group_id]
  tags               = var.tags
}

resource "time_sleep" "after_eip_detach" {
  depends_on = [huaweicloud_vpc_eip_associate.eip_1]
  destroy_duration = "45s"
}

resource "huaweicloud_vpc_eip_associate" "eip_1" {
  public_ip = module.eip_elb_public.address
  port_id   = huaweicloud_lb_loadbalancer.elb_public.vip_port_id
}

#######################################
# NAT Gateway
#######################################
module "nat_gateway" {
  source                = "../../terraform-modules/nat_gateway"
  name                  = var.ng_name
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_cce.subnet_id
  spec                  = var.ng_spec
  description           = var.ng_description
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  tags                  = var.tags
}

module "eip_nat_gateway" {
  source                = "../../terraform-modules/eip"
  eip_name              = "eip-nat-gateway"
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_nat_snat_rule" "this" {
  count          = 1
  nat_gateway_id = module.nat_gateway.nat_gateway_id
  subnet_id      = module.subnet_cce.subnet_id
  floating_ip_id = module.eip_nat_gateway.eip_id
  description    = "SNAT rule for CCE subnet internet access"
}

#######################################
# CCE
#######################################
module "eip_cce_cluster" {
  source                = "../../terraform-modules/eip"
  eip_name              = var.eip_cce_name
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

module "cce_cluster" {
  source = "../../terraform-modules/cce_cluster"

  cce_cluster_name         = var.cce_cluster_name
  cce_cluster_type         = var.cce_cluster_type
  cce_cluster_flavor       = var.cce_cluster_flavor
  cce_k8s_version          = var.cce_k8s_version
  security_group_id        = module.sg_cce.security_group_id

  #service network "10.1.32.0/19"
  cce_vpc_id               = module.vpc.vpc_id
  cce_subnet_id            = module.subnet_cce.subnet_id
  #container/pod network "172.16.0.0/16"
  cce_network_type         = var.cce_network_type
  #cce_network_cidr         = var.cce_network_cidr
  #eni network "10.1.64.0/19"
  cce_eni_subnet_id        = module.subnet_cce_eni.subnet_id
  #cce_eni_subnet_cidr      = module.subnet_cce_eni.subnet_cidr

  cce_authentication_mode  = var.cce_authentication_mode 
  cce_eip                  = module.eip_cce_cluster.address
  cce_charging_mode        = var.cce_charging_mode
  cce_availability_zone    = data.huaweicloud_availability_zones.myaz.names[0]
  cce_enteprise_project_id = data.huaweicloud_enterprise_project.ep.id

  tags                     = var.tags
}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0] 
  performance_type  = "normal" 
  cpu_core_count    = 4 
  memory_size       = 8 
} 

resource "huaweicloud_cce_node_pool" "nodepool" {
  cluster_id         = module.cce_cluster.cluster_id
  name               = "cce-nodepool-public"
  initial_node_count = 2
  subnet_id          = module.subnet_cce.subnet_id
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
  security_groups    = [module.sg_cce.security_group_id]
  key_pair           = var.key_pair_name
  extend_param = {
    agency_name = "obs-agency"
  }
  tags = var.tags
}

#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name                   = "obs-agency"
  delegated_service_name = "op_svc_ecs"

  project_role {
    project = var.region
    roles = [
      "OBS OperateAccess"
    ]
  }
}

#######################################
# DEW - Secret
#######################################
locals {
  dew_secret_payload = {
    URL      = "wwww.google.com"
    USUARIO  = "alejandro"
    PASSWORD = "P@ssw0rdSecure123!"
    PORT     = "5432"
  }
}

module "dew_secret" {
  source = "../../terraform-modules/dew"

  secret_name           = var.dew_secret_name
  secret_description    = var.dew_secret_description
  secret_payload        = local.dew_secret_payload

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Output Final
#######################################
output "resources" {
  description = "Resource information"
  value = {
    cce_name         = var.cce_cluster_name
    cce_public_ip    = module.eip_cce_cluster.address
  }
}