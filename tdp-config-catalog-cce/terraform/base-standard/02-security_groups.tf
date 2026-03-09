#######################################
# Security Groups
#######################################
resource "huaweicloud_networking_secgroup" "sg_elb" {
  name = var.security_group_elb
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
}

resource "huaweicloud_networking_secgroup_rule" "elb_ingress_https" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 443
  port_range_max = 443
  remote_ip_prefix = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
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
}

resource "huaweicloud_networking_secgroup_rule" "elb_egress_nodes" {
  security_group_id = huaweicloud_networking_secgroup.sg_elb.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
}

resource "huaweicloud_networking_secgroup_rule" "cce_control_plane_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_ip_prefix = "100.125.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "cce_control_plane_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "100.125.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "cce_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = huaweicloud_networking_secgroup.sg_cce.id
}

resource "huaweicloud_networking_secgroup_rule" "cce_api_external_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 5443
  port_range_max = 5443
  remote_ip_prefix = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "master_to_kubelet" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 10250
  port_range_max = 10250
  remote_ip_prefix = "100.64.0.0/10"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_icmp" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "100.125.0.0/16"
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_nodeport" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = 30000
  port_range_max = 32767
  remote_group_id = huaweicloud_networking_secgroup.sg_elb.id
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_worker_access" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = var.vpc_subnet_cce_cidr
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_ingress_self" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "0"
  remote_group_id = huaweicloud_networking_secgroup.sg_cce.id
}

resource "huaweicloud_networking_secgroup_rule" "cce_node_egress_all" {
  security_group_id = huaweicloud_networking_secgroup.sg_cce.id
  direction = "egress"
  ethertype = "IPv4"
  protocol = "0"
  remote_ip_prefix = "0.0.0.0/0"
}