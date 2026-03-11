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
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow HTTP traffic from Internet to Huawei ELB"
}

resource "huaweicloud_networking_secgroup_rule" "elb_ingress_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow HTTPS traffic from Internet to Huawei ELB"
}

#######################################
# Security Group Nodes (CCE workers)
#######################################
resource "huaweicloud_networking_secgroup_rule" "nodes_internal" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Allow unrestricted communication between Kubernetes worker nodes"
}

resource "huaweicloud_networking_secgroup_rule" "pods_to_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = var.vpc_subnet_cce_eni_cidr
  description       = "Allow pods in ENI subnet to communicate with worker nodes (required for kubelet logs/exec)"
}

resource "huaweicloud_networking_secgroup_rule" "controlplane_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Allow Huawei CCE control plane to communicate with worker nodes"
}

resource "huaweicloud_networking_secgroup_rule" "controlplane_nodes_alt" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "100.64.0.0/10"
  description       = "Allow alternate Huawei control plane CIDR to communicate with worker nodes"
}

resource "huaweicloud_networking_secgroup_rule" "nodes_egress" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow worker nodes outbound access to pull images and access external services"
}

#######################################
# Security Group Pods (ENI)
#######################################
resource "huaweicloud_networking_secgroup_rule" "pods_internal" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce_eni.id
  description       = "Allow communication between pods attached to ENI network interfaces"
}

resource "huaweicloud_networking_secgroup_rule" "nodes_to_pods" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
  description       = "Allow Kubernetes worker nodes to communicate with pods attached via ENI"
}

resource "huaweicloud_networking_secgroup_rule" "controlplane_pods" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "100.125.0.0/16"
  description       = "Allow CCE control plane to reach pods for logs, exec and metrics"
}

resource "huaweicloud_networking_secgroup_rule" "controlplane_pods_alt" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "100.64.0.0/10"
  description       = "Allow alternate CCE control plane CIDR to reach pods"
}

resource "huaweicloud_networking_secgroup_rule" "elb_to_pods" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 65535
  remote_group_id   = huaweicloud_networking_secgroup.sg_elb.id
  description       = "Allow Huawei ELB to forward traffic directly to pods in ENI networking mode"
}

resource "huaweicloud_networking_secgroup_rule" "pods_egress" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce_eni.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Allow pods outbound access to external services and APIs"
}