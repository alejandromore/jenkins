variable "region" {
  description = "Nombre de la region"
  type        = string
  default = ""
}

variable "access_key" {
  description = "Nombre del Grupo de Securidad"
  type        = string
  default = ""
}

variable "secret_key" {
  description = "Nombre del Grupo de Securidad"
  type        = string
  default = ""
}

variable "enterprise_project_name" {
  description = "Nombre del proyecto empresarial"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

variable "client_id" {
  description = "Client ID for OIDC provider"
  type        = string
}

variable "group_name" {
  description = "Name of the IAM group for the workload"
  type        = string
}

############################################
# Parametros del TF VARS
############################################
variable "oidc_jwks" {
  description = "JWKS from CCE cluster"
  type        = string
}

variable "namespace" {
  description = "Namespace of the workload"
  type        = string
  default     = "default"
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
  default     = ""
}