#######################################
# Enterprise Project
#######################################
data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

#######################################
# Availability Zones
#######################################
data "huaweicloud_availability_zones" "myaz" {}