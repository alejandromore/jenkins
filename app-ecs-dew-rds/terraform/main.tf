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

module "subnet_data" {
  source            = "../../terraform-modules/subnet"
  vpc_id            = module.vpc.vpc_id
  subnet_name       = var.vpc_subnet_data_name
  cidr              = var.vpc_subnet_data_cidr
  gateway_ip        = var.vpc_subnet_data_gateway_ip
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

module "sg_data" {
  source                = "../../terraform-modules/security_group"
  sg_name               = var.security_group_data_name
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Security Group Public - Rules
#######################################

#SG Public Ingress & Egress
resource "huaweicloud_networking_secgroup_rule" "public_ingress_http" {
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8081
  port_range_max    = 8081
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (8081)"
}

resource "huaweicloud_networking_secgroup_rule" "public_ingress_ssh" {
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ECS (SSH)"
}

# Egreso controlado desde ECS
resource "huaweicloud_networking_secgroup_rule" "private_egress_postgres" {
  security_group_id = module.sg_public.security_group_id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = module.sg_data.security_group_id
  description       = "ECS → RDS (PostgreSQL)"
}

#######################################
# Security Group Data - Rules
#######################################

#SG Data Ingress & Egress
resource "huaweicloud_networking_secgroup_rule" "data_ingress_postgres" { #ECS privado → RDS (PostgreSQL)
  security_group_id = module.sg_data.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_group_id   = module.sg_public.security_group_id
  description       = "ECS publico → RDS (PostgreSQL)"
}

resource "huaweicloud_networking_secgroup_rule" "data_ingress_postgres_internet" { #Internet → RDS (PostgreSQL)
  security_group_id = module.sg_data.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → RDS (PostgreSQL)"
}

#######################################
# RDS
#######################################

module "rds_postgres" {
  source = "../../terraform-modules/rds"

  name                  = var.rds_postgres_name
  flavor                = var.rds_postgres_flavor
  availability_zone     = [data.huaweicloud_availability_zones.myaz.names[0]]
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_data.subnet_id
  security_group_id     = module.sg_data.security_group_id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  db_password           = var.rds_postgres_password
  tags                  = var.tags
}

module "eip_rds_postgres" {
  source                = "../../terraform-modules/eip"
  eip_name              = "eip-rds-postgres"
  bandwidth_name        = "mieip-bandwidth"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_rds_instance_eip_associate" "associated" {
  instance_id  = module.rds_postgres.rds_id
  public_ip    = module.eip_rds_postgres.address
  public_ip_id = module.eip_rds_postgres.eip_id
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
# DEW - Secret
#######################################
locals {
  dew_secret_payload = {
    db_url      = "jdbc:postgresql://${module.rds_postgres.address[0]}:5432/postgres"
#    db_url      = "jdbc:postgresql://${module.eip_rds_postgres.address}:5432/postgres"
    db_username = "root"
    db_password = var.rds_postgres_password
    db_schema   = "dummy_data"
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
    ecs_public_name  = var.ecs_public_name
    ecs_public_ip    = module.eip_ecs_publico.address
    rds_name         = var.rds_postgres_name
    rds_private_ip   = module.rds_postgres.address[0]
    rds_public_ip    = module.eip_rds_postgres.address
  }
}
