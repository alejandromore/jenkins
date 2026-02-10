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

resource "huaweicloud_networking_secgroup_rule" "management_ingress_server" { #Internet → ECS
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 50000
  port_range_max    = 50000
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (5000 Server)"
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_rmi" { #Internet → ECS
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1099
  port_range_max    = 1099
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (1099 Server)"
}

resource "huaweicloud_networking_secgroup_rule" "management_egress_80" { #ECS → Internet
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "ECS → Internet"
}

resource "huaweicloud_networking_secgroup_rule" "management_egress_8080" { #ECS → Internet
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "ECS → Internet"
}

resource "huaweicloud_networking_secgroup_rule" "management_egress_8081" { #ECS → Internet
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8081
  port_range_max    = 8081
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "ECS → Internet"
}

#######################################
# ECS
#######################################
data "huaweicloud_compute_flavors" "myflavor" {
  availability_zone = data.huaweicloud_availability_zones.myaz.names[0]
  cpu_core_count    = 4
  memory_size       = 4
}

data "huaweicloud_images_image" "myimage" {
  name        = "Ubuntu 24.04 server 64bit"
  most_recent = true
}

resource "tls_private_key" "ecs" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.ecs.private_key_pem
  filename = "${path.module}/keys/pk-${var.ecs_public_name}.pem"
}

resource "huaweicloud_compute_keypair" "ecs" {
  name       = "kp-${var.ecs_public_name}"
  public_key = tls_private_key.ecs.public_key_openssh
}

module "ecs_publico" {
  source = "../../terraform-modules/ecs"

  ecs_name              = var.ecs_public_name
  flavor_id             = data.huaweicloud_compute_flavors.myflavor.ids[0]
  image_id              = data.huaweicloud_images_image.myimage.id
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_public.subnet_id
  security_group_id     = module.sg_public.security_group_id
  keypair_name          = huaweicloud_compute_keypair.ecs.name
  ecs_password          = null
  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

module "eip_ecs_publico" {
  source                = "../../terraform-modules/eip"
  eip_name              = "eip-${var.ecs_public_name}"
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = module.eip_ecs_publico.address
  instance_id = module.ecs_publico.ecs_id
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


