#######################################
# Security Groups
#######################################
resource "huaweicloud_networking_secgroup" "sg_elb" {
  name                  = var.security_group_elb
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup" "sg_cce" {
  name                  = var.security_group_cce
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Security Group ELB - Rules
#######################################

# Internet -> ELB HTTP
resource "huaweicloud_networking_secgroup_rule" "elb_ingress_http" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow HTTP traffic from Internet to ELB"
}

# Internet -> ELB HTTPS
resource "huaweicloud_networking_secgroup_rule" "elb_ingress_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow HTTPS traffic from Internet to ELB"
}

# ELB -> Nodes (NodePort)
resource "huaweicloud_networking_secgroup_rule" "elb_to_nodes_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Allow ELB to forward traffic to Kubernetes NodePort services"
}

#######################################
# Security Group CCE Nodes - Rules
#######################################

# ELB -> Nodes NodePort access
resource "huaweicloud_networking_secgroup_rule" "nodes_from_elb" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_group_id   = huaweicloud_networking_secgroup.sg_elb.id
  description       = "Allow ELB to access Kubernetes NodePort services on worker nodes"
}

# Huawei ELB health checks -> NodePort
resource "huaweicloud_networking_secgroup_rule" "nodes_from_elb_healthcheck" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Allow Huawei ELB health checks to NodePort services"
}

# Internal cluster communication
resource "huaweicloud_networking_secgroup_rule" "cce_internal_cluster" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_cidr
  description       = "Allow full communication between nodes, pods and control plane within CCE subnet"
}

resource "huaweicloud_networking_secgroup_rule" "cce_vxlan_overlay" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  port_range_min    = 8472
  port_range_max    = 8472
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Allow VXLAN overlay traffic between CCE nodes"
}

# Self security group communication
resource "huaweicloud_networking_secgroup_rule" "cce_internal_sg" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Allow traffic between resources that share the same CCE security group"
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
  description       = "Allow external access to Kubernetes API server"
}

# Kubelet access (logs, exec, port-forward)
resource "huaweicloud_networking_secgroup_rule" "cce_kubelet_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = var.vpc_subnet_cce_cidr
  description       = "Allow control plane and nodes to access kubelet (logs, exec, port-forward)"
}

# Outbound traffic from nodes
resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow worker nodes to access external services (image pull, updates, APIs)"
}