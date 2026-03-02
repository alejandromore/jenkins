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

  availability_zone     = data.huaweicloud_availability_zones.myaz.names[0]
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id

  vpc_name              = var.vpc_name
  vpc_cidr              = var.vpc_cidr
  subnets_configuration = var.subnets_configuration
  security_group_name   = var.security_group_name
}



#######################################
# ECS Module
#######################################
/*
module "ecs_service" {
  source = "github.com/terraform-huaweicloud-modules/terraform-huaweicloud-ecs"

  availability_zone     = data.huaweicloud_availability_zones.this.names[0]
  enterprise_project_id = huaweicloud_enterprise_project.ep.id

  instance_flavor_cpu_core_count = var.instance_flavor_cpu_core_count
  instance_flavor_memory_size    = var.instance_flavor_memory_size
  instance_image_os_type         = var.instance_image_os_type
  instance_image_architecture    = var.instance_image_architecture
  instance_name                  = var.instance_name

  instance_admin_pass         = random_password.this.result
  instance_security_group_ids = [module.vpc_service.security_group_id]
  instance_networks_configuration = [
    {
      uuid = try(module.vpc_service.subnet_ids[0], "")
    }
  ]
  use_inside_data_disks_configuration = true
  instance_disks_configuration        = var.instance_disks_configuration
}
*/