# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

#######################################
# VPC Module
#######################################
module "vpc_service" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-vpc"

  availability_zone                  = data.huaweicloud_availability_zones.myaz.names[0]
  enterprise_project_id              = data.huaweicloud_enterprise_project.ep.id
             
  vpc_name                           = var.vpc_name
  vpc_cidr                           = var.vpc_cidr
  subnets_configuration              = var.subnets_configuration
  security_group_name                = var.security_group_name
  security_group_description         = var.security_group_description
  #security_group_rules_configuration = var.security_group_rules_configuration
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_ssh" { #Internet → ECS
  security_group_id = module.vpc_service.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (22 SSH)"
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_http" { #Internet → ECS
  security_group_id = module.vpc_service.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (8080 Server)"
}

resource "huaweicloud_networking_secgroup_rule" "ecs_egress_internet" {
  security_group_id = module.vpc_service.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "0"
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "ECS → Internet (All traffic)"
}
