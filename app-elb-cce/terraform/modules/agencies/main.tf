# Create an IAM Agency
resource "huaweicloud_iam_agency" "this" {
  name                   = var.name
  description            = var.description
  delegated_service_name = var.delegated_service_name
  duration               = var.duration
  all_resources_roles    = var.all_resources_roles
}
