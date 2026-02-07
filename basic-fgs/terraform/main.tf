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
  sg_name               = var.security_group_public
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
}

#######################################
# Security Group Rules - Public
#######################################
resource "huaweicloud_networking_secgroup_rule" "public_fg_http" {
  security_group_id = module.sg_public.security_group_id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8000
  port_range_max    = 8000
  remote_ip_prefix  = "0.0.0.0/0"
  description       = "Internet → ELB (8080)"
}

#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "functiongraph_agency" {
  name                   = "functiongraph_agency"
  description            = "Agency para FunctionGraph acceso a otros servicios"
  delegated_service_name = "op_svc_cff"

  project_role {
    project = var.region
    roles = [
      "FunctionGraph FullAccess",
      "OBS OperateAccess"
    ]
  }
}

#######################################
# OBS
#######################################
/*
module "obs_app" {
  source                = "../../terraform-modules/obs"
  bucket_name           = var.obs_bucket_name
  bucket_acl            = var.obs_bucket_acl
  storage_class         = var.obs_storage_class

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

resource "huaweicloud_obs_bucket_object" "function_zip" {
  bucket = module.obs_app.bucket_name
  key    = "fg-py-hello-world.zip"
  source = "./apps/fg-py-hello-world.zip"
}
*/
#######################################
# FunctionGraph
#######################################
module "fgs_py_event" {
  source                = "../../terraform-modules/fgs"
  name                  = var.fgs_name
  runtime               = var.fgs_runtime
  memory_size           = var.fgs_memory_size
  timeout               = var.fgs_timeout
  handler               = var.fgs_handler
  app                   = "default"
  agency                = huaweicloud_identity_agency.functiongraph_agency.name
  code_type             = var.fgs_code_type
  code_url              = "https://obs-alejandro-apps.obs.${var.region}.myhuaweicloud.com/${var.app_file}"
  vpc_id                = module.vpc.vpc_id
  network_id            = module.subnet_public.subnet_id

  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  tags                  = var.tags
}

#######################################
# Output Final
#######################################
output "resources" {
  description = "Resource information"
  value = {
    function_urn  = module.fgs_py_event.function_urn
  }
}