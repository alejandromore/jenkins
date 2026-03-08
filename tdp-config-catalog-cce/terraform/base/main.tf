# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

#######################################
# VPC, Subnet and Security Groups
#######################################
resource "huaweicloud_vpc" "vpc_service" {
  name   = var.vpc_name
  cidr   = var.vpc_cidr
  region = var.region

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

resource "huaweicloud_vpc_subnet" "vpc_subnet_public" {
  vpc_id             = huaweicloud_vpc.vpc_service.id
  name               = var.vpc_subnet_public_name
  cidr               = var.vpc_subnet_public_cidr
  gateway_ip         = var.vpc_subnet_public_gateway_ip
  description        = "VPC Subnet Public"
  dns_list           = var.dns_list
  dhcp_enable        = true
  availability_zone  = data.huaweicloud_availability_zones.myaz.names[0]
  tags               = var.tags
}

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

resource "huaweicloud_vpc_bandwidth" "bandwidth_shared" {
  name = var.bandwidth_name
  size = var.bandwidth_size
}

#######################################
# Security Group
#######################################
resource "huaweicloud_networking_secgroup" "sg_public" {
  name               = var.security_group_public
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup" "sg_cce_eni" {
  name               = var.security_group_cce_eni
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup" "sg_cce" {
  name               = var.security_group_cce
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Security Group Rules - Public
#######################################
# Reglas para ELB
resource "huaweicloud_networking_secgroup_rule" "public_ingress_http" {
  security_group_id = huaweicloud_networking_secgroup.sg_public.id
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
  security_group_id = huaweicloud_networking_secgroup.sg_public.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8081
  port_range_max    = 8081
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "ELB → CCE (8081)"
}

# ELB necesita puertos efímeros para health checks y sesiones
resource "huaweicloud_networking_secgroup_rule" "public_egress_ephemeral_health" {
  security_group_id = huaweicloud_networking_secgroup.sg_public.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 32768  # Puertos efímeros típicos de Linux
  port_range_max    = 60999
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "ELB → CCE para health check y sesiones"
}

#######################################
# Security Group CCE Node - Rules 
#######################################
# --- ACCESO EXTERNO (ADMINISTRACIÓN) ---
resource "huaweicloud_networking_secgroup_rule" "cce_api_external_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
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
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
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
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9443
  port_range_max    = 9443
  remote_ip_prefix  = "100.125.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "cce_internal_control" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5444
  port_range_max    = 5444
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Puerto de control interno mandatorio para clusters CCE Turbo"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_icmp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Permitir ICMP desde el Control Plane para monitoreo de salud del nodo"
}

# --- TRÁFICO DE SERVICIOS (NODEPORT Y ELB) ---
resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_tcp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Acceso externo a servicios de red de Kubernetes via NodePort (TCP)"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport_udp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Acceso externo a servicios de red de Kubernetes via NodePort (UDP)"
}

resource "huaweicloud_networking_secgroup_rule" "private_ingress_elb_health_8080" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
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
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_cidr
  #remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Permitir comunicacion total entre nodos dentro de su propia subnet"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Permitir confianza total entre todos los miembros de este security group"
}

# --- SALIDA A INTERNET (EGRESS) ---
resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Permitir salida total a internet para descarga de imagenes y actualizaciones"
}

#######################################
# Security Group CCE ENI - Rules 
#######################################
resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_cidr" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_cidr
  description       = "Used by worker nodes to access each other and to access the master node."
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce_eni.id
  description       = "Traffic from the source IP addresses defined in the security group must be allowed."
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Default egress security group rule for CCE ENI"
}

#######################################
# ELB
#######################################
resource "huaweicloud_lb_loadbalancer" "elb_public" {
  name               = "elb-public"
  #vip_subnet_id      = module.subnet_public.ipv4_subnet_id
  vip_subnet_id     = huaweicloud_vpc_subnet.vpc_subnet_public.ipv4_subnet_id

  security_group_ids = [huaweicloud_networking_secgroup.sg_public.id]
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags               = var.tags
}

resource "huaweicloud_vpc_eip" "eip_elb" {
  name         = var.eip_elb_name
  publicip {
    type = "5_bgp" # Dynamic BGP (tipo de EIP)
  }

  bandwidth {
    share_type = "WHOLE"
    id         = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"    # Post-pago (pay-per-use)
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}


resource "huaweicloud_vpc_eip_associate" "eip_1" { 
  public_ip = huaweicloud_vpc_eip.eip_elb.address
  port_id   = huaweicloud_lb_loadbalancer.elb_public.vip_port_id
}

#######################################
# NAT Gateway
#######################################
resource "huaweicloud_vpc_eip" "eip_ng" {
  name         = var.eip_ng_name
  publicip {
    type = "5_bgp" # Dynamic BGP (tipo de EIP)
  }

  bandwidth {
    share_type = "WHOLE"
    id         = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"    # Post-pago (pay-per-use)
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

# NAT Gateway (solo el recurso NAT)
resource "huaweicloud_nat_gateway" "cce_nat_gateway" {
  name                = var.ng_name
  vpc_id              = huaweicloud_vpc.vpc_service.id
  subnet_id           = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  spec                = var.ng_spec
  description         = var.ng_description
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  tags = var.tags
}

resource "huaweicloud_nat_snat_rule" "this" {
  count          = 1
  nat_gateway_id = huaweicloud_nat_gateway.cce_nat_gateway.id
  subnet_id      = huaweicloud_vpc_subnet.vpc_subnet_cce.id
  floating_ip_id = huaweicloud_vpc_eip.eip_ng.id
  description    = "SNAT rule for CCE subnet internet access"
}

resource "huaweicloud_nat_snat_rule" "snat_cce_pods" {
  nat_gateway_id = huaweicloud_nat_gateway.cce_nat_gateway.id
  subnet_id      = huaweicloud_vpc_subnet.vpc_subnet_cce_eni.id
  floating_ip_id = huaweicloud_vpc_eip.eip_ng.id
  description    = "SNAT rule for CCE Turbo Pods (ENI Subnet)"
}

#######################################
# CCE
#######################################
resource "huaweicloud_vpc_eip" "eip_cce" {
  name         = var.eip_cce_name
  publicip {
    type = "5_bgp" # Dynamic BGP (tipo de EIP)
  }

  bandwidth {
    share_type = "WHOLE"
    id         = huaweicloud_vpc_bandwidth.bandwidth_shared.id
  }
  charging_mode = "postPaid"    # Post-pago (pay-per-use)
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags = var.tags
}

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
    eni_subnet_id                = huaweicloud_vpc_subnet.vpc_subnet_cce_eni.ipv4_subnet_id
    enterprise_project_id        = data.huaweicloud_enterprise_project.ep.id
    flavor_id                    = var.cce_cluster_flavor
    highway_subnet_id            = null
    ipv6_enable                  = false
    kube_proxy_mode              = "iptables"
    name                         = var.cce_cluster_name
    region                       = var.region
    security_group_id            = huaweicloud_networking_secgroup.sg_cce.id
    service_network_cidr         = var.cce_network_cidr
    subnet_id                    = huaweicloud_vpc_subnet.vpc_subnet_cce.id
    support_istio                = true
    tags                         = var.tags
    timezone                     = "America/Lima"
    vpc_id                       = huaweicloud_vpc.vpc_service.id
    eip                          = huaweicloud_vpc_eip.eip_cce.address

    masters {
        availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
    }
}

#######################################
# Instalar Add On
#######################################
resource "huaweicloud_cce_addon" "secrets_manager_dew" {
  cluster_id    = huaweicloud_cce_cluster.cce_cluster_turbo.id
  template_name = "dew-provider"
  version       = "1.1.95"

  values {

    basic = {
      dewEndpoint                = "https://kms.la-south-2.myhuaweicloud.com"
      dew_provider_image_version = "1.1.95"
      region                     = var.region
      swr_addr                   = "swr.la-south-2.myhuaweicloud.com"
      swr_user                   = "hwofficial"
      rbac_enabled               = "true"
      cluster_version            = var.cce_k8s_version
    }

    custom = {
      agency_name           = ""
      rotation_poll_interval = "2m"
      aksk_secret_name      = "paas.elb"
      driver_writes_secrets = "false"
      get_version_burst     = "5"
      get_version_qps       = "5"
      project_id            = data.huaweicloud_enterprise_project.ep.id
    }

    flavor = {
      name = "custom-resources"
    }
  }
}

#######################################
# Guardar valores en el KMS - Secrets
#######################################
data "huaweicloud_kms_key" "infra_key" {
  key_alias = var.key_alias
}

resource "huaweicloud_csms_secret" "cluster_id" {
  name        = "infra_base_cluster_id"
  description = "CCE Cluster ID"
  kms_key_id  = data.huaweicloud_kms_key.infra_key.id

  secret_text = huaweicloud_cce_cluster.cce_cluster_turbo.id
}

resource "huaweicloud_csms_secret" "subnet_id" {
  name        = "infra_base_cce_subnet_id"
  description = "CCE Subnet ID"
  kms_key_id  = data.huaweicloud_kms_key.infra_key.id

  secret_text = huaweicloud_vpc_subnet.vpc_subnet_cce.id
}

resource "huaweicloud_csms_secret" "cce_sg_id" {
  name        = "infra_base_cce_sg_id"
  description = "CCE Security Group ID"
  kms_key_id  = data.huaweicloud_kms_key.infra_key.id

  secret_text = huaweicloud_networking_secgroup.sg_cce.id
}
