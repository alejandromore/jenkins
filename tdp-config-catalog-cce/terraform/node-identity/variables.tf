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

variable "key_pair_name" {
  description = "Nombre del Key Pair para los nodos"
  type        = string
}

variable "key_alias" {
  description = "Alias del KMS Key para cifrar secretos"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

