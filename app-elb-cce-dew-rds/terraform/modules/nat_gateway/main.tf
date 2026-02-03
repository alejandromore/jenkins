# NAT Gateway (solo el recurso NAT)
resource "huaweicloud_nat_gateway" "this" {
  name                = var.name
  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  spec                = var.spec
  description         = var.description
  enterprise_project_id = var.enterprise_project_id

  tags = var.tags
}