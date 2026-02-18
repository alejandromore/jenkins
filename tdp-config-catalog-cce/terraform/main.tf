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

# --- ACCESO EXTERNO (ADMINISTRACIÓN) ---

resource "huaweicloud_networking_secgroup_rule" "cce_api_external_access" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5443
  port_range_max    = 5443
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Permitir acceso a la API de Kubernetes (kubectl) desde el exterior"
}

# --- COMUNICACIÓN CON CONTROL PLANE (MASTER) ---

resource "huaweicloud_networking_secgroup_rule" "master_to_kubelet" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  #remote_ip_prefix  = "100.125.0.0/16"
  remote_ip_prefix  = "0.0.0.0/0" # SOLO PARA PRUEBA TEMPORAL
  description       = "Permitir al Control Plane acceder al API del Kubelet para logs y exec"
}

resource "huaweicloud_networking_secgroup_rule" "cce_turbo_addon_comm" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9443
  port_range_max    = 9443
  remote_ip_prefix  = "100.125.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "cce_internal_control" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5444
  port_range_max    = 5444
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Puerto de control interno mandatorio para clusters CCE Turbo"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_icmp" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Permitir ICMP desde el Control Plane para monitoreo de salud del nodo"
}

# --- TRÁFICO DE SERVICIOS (NODEPORT Y ELB) ---

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_tcp" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Acceso externo a servicios de red de Kubernetes via NodePort (TCP)"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_udp" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Acceso externo a servicios de red de Kubernetes via NodePort (UDP)"
}

resource "huaweicloud_networking_secgroup_rule" "private_ingress_elb_health_8080" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Permitir Health Checks del ELB de Huawei Cloud (puerto 8080)"
}

# --- CONFIANZA INTERNA (RED DEL CLUSTER) ---

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_worker_access" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_cidr
  description       = "Permitir comunicacion total entre nodos dentro de su propia subnet"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = module.sg_cce.security_group_id
  description       = "Permitir confianza total entre todos los miembros de este security group"
}

# --- SALIDA A INTERNET (EGRESS) ---

resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = module.sg_cce.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Permitir salida total a internet para descarga de imagenes y actualizaciones"
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

resource "huaweicloud_nat_snat_rule" "snat_cce_pods" {
  nat_gateway_id = module.nat_gateway.nat_gateway_id
  subnet_id      = module.subnet_cce_eni.subnet_id
  floating_ip_id = module.eip_nat_gateway.eip_id
  description    = "SNAT rule for CCE Turbo Pods (ENI Subnet)"
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
/*
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
*/


resource "huaweicloud_cce_cluster" "cce_cluster_turbo" {
    alias                        = var.cce_cluster_name
    authentication_mode          = var.cce_authentication_mode 
    charging_mode                = var.cce_charging_mode
    cluster_type                 = var.cce_cluster_type
    cluster_version              = var.cce_k8s_version
    container_network_cidr       = null
    container_network_type       = var.cce_network_type
    custom_san                   = []
    description                  = null
    enable_distribute_management = false
    eni_subnet_cidr              = null
    eni_subnet_id                = module.subnet_cce_eni.ipv4_subnet_id
    enterprise_project_id        = data.huaweicloud_enterprise_project.ep.id
    flavor_id                    = var.cce_cluster_flavor
    highway_subnet_id            = null
    ipv6_enable                  = false
    kube_proxy_mode              = "iptables"
    name                         = var.cce_cluster_name
    region                       = var.region
    security_group_id            = module.sg_cce.security_group_id
    service_network_cidr         = var.cce_network_cidr
    subnet_id                    = module.subnet_cce.subnet_id
    support_istio                = true
    tags                         = var.tags
    timezone                     = "America/Lima"
    vpc_id                       = module.vpc.vpc_id
    eip                          = module.eip_cce_cluster.address

    masters {
        availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
    }
}

data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0] 
  performance_type  = "computingv3" 
  generation        = "c7" 
  cpu_core_count    = 4 
  memory_size       = 8 
} 

resource "huaweicloud_cce_node_pool" "nodepool" {
  cluster_id         = huaweicloud_cce_cluster.cce_cluster_turbo.id
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
    agency_name = huaweicloud_identity_agency.obs_workload_agency.name
  }
  tags = var.tags
}



#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "obs_workload_agency" {
  name                  = "cce-workload-agency"
  description           = "Agencia para workloads en CCE"

  delegated_domain_name = "hwstaff_intl_a00392472"

  enterprise_project_roles {
    enterprise_project = var.enterprise_project_name
    roles              = ["OBS Administrator", "CSMS FullAccess"]
  }
}

############################################
# Identity Provider (OIDC)
############################################

resource "huaweicloud_identity_provider" "cce_oidc" {
  name     = "cce-workload-oidc"
  protocol = "oidc"

  access_config {
    # Para Workload Identity debe ser program
    access_type = "program"

    # Issuer URL del cluster CCE Turbo
    provider_url = "https://oidc.cce.${var.region}.myhuaweicloud.com/id/${huaweicloud_cce_cluster.cce_cluster_turbo.id}"

    # Debe coincidir con el audience (aud) del token del ServiceAccount
    client_id = "huawei-cce"

    # JWKS obtenido con:
    # kubectl get --raw /openid/v1/jwks
    signing_key = jsonencode({
      keys = [
        {
          use = "sig"
          kty = "RSA"
          kid = "n5jiym54iuC-e9Duf29jjMJ7OmqoO8tRWvlld7-QfFI"
          alg = "RS256"
          n   = "xjl9H8qop2rEj4Rd1mryNhpqmAb5RL1VL8iXQHxJmNzMsjYykR4G3raGFfEDqO9n5eBXwGLNqilrLj_HfFJADl93Pb5sfBJUvzBMabduxI1SUlATouaBW2HPl-yHzPgnCrZtfUB2A9k8AKFSXhSZ6TSb_vEkjmvJ4FmoFJhjiivLBFh1FzlnhCGFmm6_KcBJaZrOSohDc2Fa-4eHTOsuC8fnEuDwaHpH-BgJNtMu-Op2hMNkpUrZb08Ng1bLHJuBsxk5Vr0Iv6rPfB92xpQTybnm-qGfq9S0KZb-F0PrOg1opDkJT7lnwYeT3ci5BhbCCW7yfU5Qb9k8s1wEw0laY_dc61Knc5bgQzk5yPOu05_q6066z0JG3GYZJGs6hCHxz_1NIWDhLFIAJlVQozgDhCNNhpQcmud3B81Be9-jdglPfdntLd8s6WHItWhlNV20NX4k6gPn4B3kUxrbXN_KIyoqLDyI7AQ-Tq-idaHeLnrSRHh1KCLpvjVX13apz-Qf"
          e   = "AQAB"
        }
      ]
    })
  }
}




# 1. Identity Provider (Configuración base)
/*
resource "huaweicloud_identity_provider" "cce_oidc" {
  name        = "cce-config-catalog-idp"
  protocol    = "oidc"

  access_config {
    access_type  = "program"
    provider_url = "https://oidc.${var.region}.myhuaweicloud.com/id/${huaweicloud_cce_cluster.cce_cluster_turbo.id}"
    client_id    = "sts.myhuaweicloud.com"
    signing_key  = huaweicloud_cce_cluster.cce_cluster_turbo.certificate_clusters[0].certificate_authority_data
  }
}

# 2. Mapeo de Identidad usando Heredoc (v1.86.0)
resource "huaweicloud_identity_provider_mapping" "cce_sa_mapping" {
  provider_id = huaweicloud_identity_provider.cce_oidc.id

  # Siguiendo la referencia oficial: argumento string con formato JSON
  mapping_rules = <<RULES
[
    {
        "local": [
            {
                "agency": "${huaweicloud_identity_agency.obs_workload_agency.name}"
            }
        ],
        "remote": [
            {
                "type": "sub",
                "any_one_of": [
                    "system:serviceaccount:default:sa-obs",
                    "system:serviceaccount:default:sa-dew"
                ]
            }
        ]
    }
]
RULES
}
*/
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