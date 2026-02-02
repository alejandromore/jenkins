resource "huaweicloud_csms_secret" "this" {
  name                  = var.secret_name
  description           = var.secret_description
  enterprise_project_id = var.enterprise_project_id

  secret_text = jsonencode(var.secret_payload)
}