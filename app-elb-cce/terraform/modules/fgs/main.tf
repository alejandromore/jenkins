resource "huaweicloud_fgs_function" "this" {
  name                  = var.name
  runtime               = var.runtime
  memory_size           = var.memory_size
  timeout               = var.timeout
  handler               = var.handler
  app                   = var.app
  agency                = var.agency
  code_type             = var.code_type
  code_url              = var.code_url

  vpc_id                = var.vpc_id
  network_id            = var.network_id

  tags                  = var.tags
  enterprise_project_id = var.enterprise_project_id
}
