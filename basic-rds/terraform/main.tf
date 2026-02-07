# Enterprise Project
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

data "huaweicloud_availability_zones" "myaz" {}

#######################################
# VPC Module
#######################################

module "vpc" {
  source            = "../../modules/vpc"
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
  source            = "../../modules/subnet"
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
  source                = "../../modules/security_group"
  sg_name               = var.security_group_public_name
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

resource "huaweicloud_networking_secgroup_rule" "management_ingress_postgres" { #Internet → RDS (PostgreSQL)
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = "0.0.0.0/0"
}

#######################################
# RDS
#######################################
module "rds_postgres" {
  source = "../../modules/rds"

  name                  = var.rds_postgres_name
  flavor                = var.rds_postgres_flavor
  availability_zone     = [data.huaweicloud_availability_zones.myaz.names[0]]
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.subnet_public.subnet_id
  security_group_id     = module.sg_public.security_group_id
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  db_password           = var.rds_postgres_password
  tags                  = var.tags
}

module "eip_rds_postgres" {
  source                = "../../modules/eip"
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
# Output Final
#######################################
output "resources" {
  description = "Resource information"
  value = {
    rds_name               = var.rds_postgres_name
    rds_private_ip         = module.rds_postgres.address[0]
    rds_public_ip          = module.eip_rds_postgres.address
  }
}

