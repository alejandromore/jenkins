# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

#######################################
# VPC Module
#######################################
module "vpc" {
  source            = "${var.modules_base_path}vpc"
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
  source            = "${var.modules_base_path}subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_public_name
  cidr              = var.vpc_subnet_public_cidr
  gateway_ip        = var.vpc_subnet_public_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

module "subnet_cce" {
  source            = "${var.modules_base_path}subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_cce_name
  cidr              = var.vpc_subnet_cce_cidr
  gateway_ip        = var.vpc_subnet_cce_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

module "subnet_cce_eni" {
  source            = "${var.modules_base_path}subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_cce_eni_name
  cidr              = var.vpc_subnet_cce_eni_cidr
  gateway_ip        = var.vpc_subnet_cce_eni_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

module "subnet_data" {
  source            = "${var.modules_base_path}subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_data_name
  cidr              = var.vpc_subnet_data_cidr
  gateway_ip        = var.vpc_subnet_data_gateway_ip
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  dns_list          = var.dns_list
  tags              = var.tags
}

#######################################
# Security Group
#######################################
module "sg_public" {
  source                = "${var.modules_base_path}security_group"
  sg_name               = var.security_group_public
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

module "sg_cce_eni" {
  source                = "${var.modules_base_path}security_group"
  sg_name               = var.security_group_cce_eni
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

module "sg_cce" {
  source                = "${var.modules_base_path}security_group"
  sg_name               = var.security_group_cce
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

module "sg_data" {
  source                = "${var.modules_base_path}security_group"
  sg_name               = var.security_group_data
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
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ELB (8080)"
}
# ELB necesita comunicarse con ECS para tráfico de aplicación
resource "huaweicloud_networking_secgroup_rule" "public_egress_to_private" {
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_group_id   = module.sg_cce.security_group_id
  description       = "ELB → CCE (8080)"
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
# Security Group Data - Rules
#######################################
resource "huaweicloud_networking_secgroup_rule" "data_ingress_postgres" {
  security_group_id = module.sg_data.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = module.sg_cce.security_group_id
  description       = "CCE → RDS (PostgreSQL)"
}

resource "huaweicloud_networking_secgroup_rule" "data_ingress_internet" {
  security_group_id = module.sg_data.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → RDS (PostgreSQL)"
}

#######################################
# ELB
#######################################
module "eip_elb_public" {
  source                = "${var.modules_base_path}eip"
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

resource "huaweicloud_vpc_eip_associate" "eip_1" {
  public_ip = module.eip_elb_public.address
  port_id   = huaweicloud_lb_loadbalancer.elb_public.vip_port_id
}

#######################################
# NAT Gateway
#######################################
module "nat_gateway" {
  source                = "${var.modules_base_path}nat_gateway"
  name                  = var.ng_name
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_cce.subnet_id
  spec                  = var.ng_spec
  description           = var.ng_description
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  tags                  = var.tags
}

module "eip_nat_gateway" {
  source                = "${var.modules_base_path}eip"
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
# RDS
#######################################
module "rds_postgres" {
  source = "${var.modules_base_path}rds"

  name                  = var.rds_postgres_name
  flavor                = var.rds_postgres_flavor
  availability_zone     = [data.huaweicloud_availability_zones.myaz.names[0]]
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_data.subnet_id
  security_group_id     = module.sg_data.security_group_id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  db_password           = var.rds_postgres_password
  tags                  = var.tags
}

module "eip_rds_postgres" {
  source                = "${var.modules_base_path}eip"
  eip_name              = "eip-rds-postgres"
  bandwidth_name        = "eip-rds-postgres-bw"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_rds_instance_eip_associate" "associated" {
  instance_id  = module.rds_postgres.rds_id
  public_ip    = module.eip_rds_postgres.address
  public_ip_id = module.eip_rds_postgres.eip_id
}

#######################################
# CCE
#######################################
module "eip_cce_cluster" {
  source                = "${var.modules_base_path}eip"
  eip_name              = var.eip_cce_name
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

module "cce_cluster" {
  source = "${var.modules_base_path}cce_cluster"

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
  cce_network_cidr         = var.cce_network_cidr
  #eni network "10.1.64.0/19"
  cce_eni_subnet_id        = module.subnet_cce_eni.subnet_id
  cce_eni_subnet_cidr      = module.subnet_cce_eni.subnet_cidr

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
  tags = var.tags

  password          = var.cce_node_password
  # key_pair         = var.cce_node_keypair_name
}

#######################################
# DEW - Secret
#######################################
locals {
  dew_secret_payload = {
    db_url      = "jdbc:postgresql://${module.rds_postgres.address[0]}:5432/postgres"
#    db_url      = "jdbc:postgresql://${module.eip_rds_postgres.address}:5432/postgres"
    db_username = "root"
    db_password = var.rds_postgres_password
    db_schema   = "dummy_data"
  }
}

module "dew_secret" {
  source = "${var.modules_base_path}dew"

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
    rds_name         = var.rds_postgres_name
    rds_name_ip      = module.rds_postgres.address[0]
    rds_public_ip    = module.eip_rds_postgres.address

    cce_name         = var.cce_cluster_name
    cce_public_ip    = module.eip_cce_cluster.address
  }
}