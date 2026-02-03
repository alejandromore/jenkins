# VPC
resource "huaweicloud_vpc" "this" {
  name = var.name
  cidr = var.cidr
  enterprise_project_id = var.project_id
  region = var.region
  tags = var.tags
}