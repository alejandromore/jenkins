data "huaweicloud_enterprise_project" "ep" {
  name = var.enterprise_project_name
}

resource "huaweicloud_kms_key" "infra_key" {
  key_alias               = "alias/infra-secrets-key"
  key_description = "KMS key for infrastructure secrets"
  enterprise_project_id = data.huaweicloud_enterprise_project.ep.id
  is_enabled      = true
}

