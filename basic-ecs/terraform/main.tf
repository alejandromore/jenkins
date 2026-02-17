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

#######################################
# Security Group
#######################################
module "sg_public" {
  source                = "../../terraform-modules/security_group"
  sg_name               = var.security_group_public_name
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_ssh" { #Internet → ECS
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (22 SSH)"
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_http" { #Internet → ECS
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (8080 Server)"
}

#######################################
# ECS
#######################################
data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  performance_type  = "normal"
  cpu_core_count    = 2
  memory_size       = 4
}

data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 24.04 server 64bit"
  most_recent = true
}

module "ecs_publico" {
  source = "../../terraform-modules/ecs"

  ecs_name              = var.ecs_public_name
  flavor_id             = data.huaweicloud_compute_flavors.myflavor.ids[0]
  image_id              = data.huaweicloud_images_image.myimage.id
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_public.subnet_id
  security_group_id     = module.sg_public.security_group_id
  keypair_name          = var.key_pair_name
  ecs_password          = null
  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  user_data             = var.cloud_init_config
  agency_name           = huaweicloud_identity_agency.obs_agency.name 
  tags                  = var.tags
}

module "eip_ecs_publico" {
  source                = "../../terraform-modules/eip"
  eip_name              = "eip-ecs-public"
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = module.eip_ecs_publico.address
  instance_id = module.ecs_publico.ecs_id
}

#######################################
# Agency
#######################################
/*
resource "huaweicloud_identity_agency" "obs_agency" {
  name                   = "cce-obs-agency"
  delegated_service_name = "op_svc_ecs"

  project_role {
    project = var.region
    roles = [
      "OBS Administrator",
      "Tenant Guest"
    ]
  }
}
*/

resource "huaweicloud_identity_agency" "obs_agency" {
  name                   = "cce-obs-agency"
  delegated_service_name = "op_svc_ecs"

  project_role {
    project = "0371a9a7f90b493fadebbf130f6fcd2c"
    roles   = ["OBS Administrator"]
  }
}

#######################################
# Output Final
#######################################

output "resources" {
  description = "Resource information"
  value = {
    ecs_name               = var.ecs_public_name
    ecs_public_ip          = module.eip_ecs_publico.address
  }
}


