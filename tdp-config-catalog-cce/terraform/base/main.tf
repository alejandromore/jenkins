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
resource "huaweicloud_networking_secgroup" "sg_elb" {
  name               = var.security_group_elb
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
# Security Group ELB - Rules
#######################################
# Internet → ELB HTTP
resource "huaweicloud_networking_secgroup_rule" "elb_ingress_http" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  description = "Allow inbound HTTP traffic from the Internet to the Elastic Load Balancer"
}

# Internet → ELB HTTPS
resource "huaweicloud_networking_secgroup_rule" "elb_ingress_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  description = "Allow inbound HTTPS traffic from the Internet to the Elastic Load Balancer"
}

# ELB → Kubernetes NodePort
resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow the ELB to forward traffic to Kubernetes NodePort services running on worker nodes"
}

#######################################
# Security Group CCE Nodes - Rules
#######################################
resource "huaweicloud_networking_secgroup_rule" "elb_to_nodes_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "0"
  remote_group_id  = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow all traffic from ELB to worker nodes for load balancing and health checks"
}

resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction        = "egress"
  ethertype        = "IPv4"
  protocol         = "0"
  remote_group_id  = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow ELB to communicate with worker nodes"
}

resource "huaweicloud_networking_secgroup_rule" "cce_control_plane_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow CCE control plane to perform ELB health checks on Kubernetes NodePort services"
}

# Kubernetes API external access
resource "huaweicloud_networking_secgroup_rule" "cce_api_external_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5443
  port_range_max    = 5443
  remote_ip_prefix  = "0.0.0.0/0"
  description = "Allow external access to the Kubernetes API server exposed by the CCE cluster"
}

# Control plane → kubelet
resource "huaweicloud_networking_secgroup_rule" "master_to_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow CCE control plane to access kubelet on worker nodes for logs, exec and metrics"
}

# Internal control communication
resource "huaweicloud_networking_secgroup_rule" "cce_internal_control" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5444
  port_range_max    = 5444
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow internal control communication required by CCE Turbo clusters"
}

# Addon communication
resource "huaweicloud_networking_secgroup_rule" "cce_turbo_addon_comm" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9443
  port_range_max    = 9443
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow communication between the CCE control plane and cluster addons"
}

# Control plane health checks
resource "huaweicloud_networking_secgroup_rule" "cce_node_icmp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow ICMP traffic from the CCE control plane for node health monitoring"
}

# ELB → NodePort
resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_group_id   = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow traffic from the Elastic Load Balancer to Kubernetes NodePort services"
}

# Worker node internal communication
resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_worker_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_cidr
  description = "Allow full communication between worker nodes within the CCE subnet"
}

# Worker nodes within same security group
resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow unrestricted communication between instances belonging to the same security group"
}

# Outbound internet access
resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description = "Allow outbound internet access for worker nodes to pull container images and access external services"
}

#######################################
# Security Group CCE ENI - Rules
#######################################
# Pods accessible within VPC
resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_cidr" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_cidr
  description = "Allow traffic within the VPC so worker nodes and services can communicate with pods using ENI IPs"
}

# Pods communication within ENI group
resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce_eni.id
  description = "Allow communication between pods that belong to the same ENI security group"
}

# Worker nodes → pods
resource "huaweicloud_networking_secgroup_rule" "cce_eni_from_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow worker nodes to communicate with pods attached through ENI network interfaces"
}

# Pods outbound
resource "huaweicloud_networking_secgroup_rule" "cce_eni_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description = "Allow outbound traffic from pods to external services or the internet"
}

#######################################
# ELB
#######################################
resource "huaweicloud_lb_loadbalancer" "elb_public" {
  name               = "elb-public"
  vip_subnet_id     = huaweicloud_vpc_subnet.vpc_subnet_cce.ipv4_subnet_id

  security_group_ids = [huaweicloud_networking_secgroup.sg_elb.id]
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
