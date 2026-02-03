# 1. Instancia de APIG - RECURSO PRINCIPAL
resource "huaweicloud_apig_instance" "this" {
  name                            = var.apig_name
  edition                         = var.apig_edition
  description                     = var.apig_description
  vpc_id                          = var.vpc_id
  subnet_id                       = var.subnet_id
  security_group_id               = var.security_group_id

  bandwidth_size                  = var.apig_bandwith_size
  ingress_bandwidth_size          = var.apig_ingress_bandwith_size
  ingress_bandwidth_charging_mode = var.apig_ingress_charging
  availability_zones              = var.apig_azs

  enterprise_project_id           = var.enterprise_project_id
  tags                            = var.tags
  region                          = var.region

}

# 2. Grupo de APIs - DEPENDE de la instancia
resource "huaweicloud_apig_group" "api_group" {
  instance_id           = huaweicloud_apig_instance.this.id
  name                  = var.api_group_name
  description           = var.api_group_description
}

# 3. Environment/Stage - DEPENDE de la instancia
resource "huaweicloud_apig_environment" "environment" {
  instance_id           = huaweicloud_apig_instance.this.id
  name                  = var.apig_stage_name
  description           = var.apig_stage_description
}

