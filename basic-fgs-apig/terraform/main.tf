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
module "sg_public" { #internet -> sg_public
  source                = "../../terraform-modules/security_group"

  sg_name               = var.security_group_public_name
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  ingress_rules = [
    {
      protocol  = "tcp"
      port      = "8080"
      remote_ip = "0.0.0.0/0"
    }
  ]

  egress_rules = [
    {
      protocol  = "tcp"
      port      = "8080"
      remote_ip = var.vpc_subnet_private_cidr
    }
  ]
}

#######################################
# APIG
#######################################
module "apig_basic" {
  source = "../../terraform-modules/apig"
  
  apig_name                  = var.apig_name
  apig_edition               = var.apig_edition
  apig_description           = var.apig_description
  apig_bandwith_size         = var.apig_bandwith_size
  apig_ingress_bandwith_size = var.apig_ingress_bandwith_size
  apig_ingress_charging      = var.apig_ingress_charging
  apig_azs                   = data.huaweicloud_availability_zones.myaz.names
  apig_stage_name            = var.apig_stage_name
  apig_stage_description     = var.apig_stage_description

  api_group_name             = var.api_group_name
  api_group_description      = var.api_group_description
     
  vpc_id                     = module.vpc.vpc_id
  subnet_id                  = module.subnet_public.subnet_id
  security_group_id          = module.sg_public.security_group_id
  region                     = var.region
  enterprise_project_id      = data.huaweicloud_enterprise_project.ep.id
  tags                       = var.tags
}

#######################################
# Agency
#######################################
resource "huaweicloud_identity_agency" "functiongraph_agency" {
  name                   = "functiongraph_agency"
  description            = "Agency para FunctionGraph acceder a APIG"
  delegated_service_name = "op_svc_cff"

  project_role {
    project = var.region
    roles = [
      "FunctionGraph FullAccess",
      "APIG FullAccess",
      "OBS OperateAccess"
    ]
  }
}

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
# API en APIG Gateway
#######################################
resource "huaweicloud_apig_api" "function_api" {
  instance_id = module.apig_basic.apig_instance_id
  group_id    = module.apig_basic.api_group_id

  name        = "api_${module.fgs_py_event.name}"
  type        = "Public"
  description = "API para invocar FunctionGraph"

  request_protocol        = "HTTPS"
  request_method          = "GET"
  request_path            = "/${module.fgs_py_event.name}"
  security_authentication = "NONE"

  mock {
    status_code    = 200
  }

  cors = true
}

resource "huaweicloud_apig_api_publishment" "function_api_release" {
  instance_id = module.apig_basic.apig_instance_id
  api_id      = huaweicloud_apig_api.function_api.id
  env_id      = module.apig_basic.stage_id
}

#######################################
# Output Final
#######################################
output "resources" {
  description = "Resource information"
  value = {
    apig  = module.apig_basic
  }
}