#######################################
# Security Groups
#######################################
resource "huaweicloud_networking_secgroup" "sg_elb" {
  name = var.security_group_elb
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup" "sg_cce_eni" {
  name = var.security_group_cce_eni
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup" "sg_cce" {
  name = var.security_group_cce
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Security Group ELB - Rules
#######################################
resource "huaweicloud_networking_secgroup_rule" "elb_ingress_http" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_ip_prefix = "0.0.0.0/0"
  description = "Allow inbound HTTP traffic from the Internet to the Elastic Load Balancer"
}

resource "huaweicloud_networking_secgroup_rule" "elb_ingress_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_ip_prefix = "0.0.0.0/0"
  description = "Allow inbound HTTPS traffic from the Internet to the Elastic Load Balancer"
}

resource "huaweicloud_networking_secgroup_rule" "elb_to_pods" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 80
  port_range_max = 80
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow ELB to reach pods directly in CCE Turbo ENI mode"
}

resource "huaweicloud_networking_secgroup_rule" "elb_to_pods_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow ELB to reach pods directly in CCE Turbo ENI mode"
}

resource "huaweicloud_networking_secgroup_rule" "elb_to_pods_healthcheck" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 1024
  port_range_max = 65535
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow ELB health checks to reach pods"
}

resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow the ELB to forward traffic to Kubernetes NodePort services running on worker nodes"
}

#######################################
# Security Group CCE Nodes - Rules
#######################################
resource "huaweicloud_networking_secgroup_rule" "elb_to_nodes_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow all traffic from ELB to worker nodes for load balancing and health checks"
}

resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow ELB to communicate with worker nodes"
}

resource "huaweicloud_networking_secgroup_rule" "cce_control_plane_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow CCE control plane to perform ELB health checks on Kubernetes NodePort services"
}

resource "huaweicloud_networking_secgroup_rule" "cce_control_plane_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow all traffic from CCE control plane to worker nodes (logs, exec, metrics, health checks)"
}

resource "huaweicloud_networking_secgroup_rule" "cce_api_external_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5443
  port_range_max = 5443
  remote_ip_prefix = "0.0.0.0/0"
  description = "Allow external access to the Kubernetes API server exposed by the CCE cluster"
}

resource "huaweicloud_networking_secgroup_rule" "master_to_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 10250
  port_range_max = 10250
  #remote_ip_prefix = "100.64.0.0/10"
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow kubelet access from control plane and nodes"
}

resource "huaweicloud_networking_secgroup_rule" "cce_nodes_kubelet_internal" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow kubelet communication between nodes"
}

resource "huaweicloud_networking_secgroup_rule" "eni_pods_to_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = var.vpc_subnet_cce_eni_cidr
  description = "Allow ENI pods to reach kubelet for logs/exec"
}

resource "huaweicloud_networking_secgroup_rule" "eni_pods_to_nodes_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_eni_cidr
  description = "Allow pod ENI subnet to communicate with nodes"
}

resource "huaweicloud_networking_secgroup_rule" "master_to_kubelet_alt" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = "100.64.0.0/10"
  description = "Allow kubelet access from CCE control plane alternate CIDR"
}

resource "huaweicloud_networking_secgroup_rule" "cce_internal_control" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5444
  port_range_max = 5444
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow internal control communication required by CCE Turbo clusters"
}

resource "huaweicloud_networking_secgroup_rule" "cce_turbo_addon_comm" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 9443
  port_range_max = 9443
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow communication between the CCE control plane and cluster addons"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_icmp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow ICMP traffic from the CCE control plane for node health monitoring"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow traffic from the Elastic Load Balancer to Kubernetes NodePort services"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_worker_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = var.vpc_subnet_cce_cidr
  description = "Allow full communication between worker nodes within the CCE subnet"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow unrestricted communication between instances belonging to the same security group"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "0.0.0.0/0"
  description = "Allow outbound internet access for worker nodes to pull container images and access external services"
}

#######################################
# Security Group CCE ENI - Rules
#######################################
resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_cidr" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = var.vpc_cidr
  description = "Allow traffic within the VPC so worker nodes and services can communicate with pods using ENI IPs"
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  description = "Allow communication between pods that belong to the same ENI security group"
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_from_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
  description = "Allow worker nodes to communicate with pods attached through ENI network interfaces"
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_control_plane" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "100.125.0.0/16"
  description = "Allow CCE control plane to reach pods in ENI mode"
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_control_plane_ports" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1024
  port_range_max    = 65535
  remote_ip_prefix  = "100.125.0.0/16"
  description = "Allow control plane connections to pods (logs, exec, proxy)"
}

resource "huaweicloud_networking_secgroup_rule" "elb_to_pods_targetport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10080
  port_range_max    = 10080
  remote_group_id   = huaweicloud_networking_secgroup.sg_elb.id
  description = "Allow ELB to reach Envoy target port"
}

resource "huaweicloud_networking_secgroup_rule" "cce_eni_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "0.0.0.0/0"
  description = "Allow outbound traffic from pods to external services or the internet"
}