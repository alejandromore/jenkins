# ============================================================================
# VARIABLES REQUERIDAS
# ============================================================================

variable "apig_name" {
  description = "Nombre de la instancia de API Gateway"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred"
  type        = string
}

variable "security_group_id" {
  description = "ID del grupo de seguridad"
  type        = string
}

variable "api_group_name" {
  description = "Nombre del grupo de APIs"
  type        = string
}

variable "apig_stage_name" {
  description = "Nombre del environment/stage"
  type        = string
}

# ============================================================================
# VARIABLES OPCIONALES CON VALORES POR DEFECTO
# ============================================================================

variable "apig_edition" {
  description = "Edición del API Gateway"
  type        = string
  default     = "BASIC"
}

variable "region" {
  description = "Región de Huawei Cloud"
  type        = string
  default     = "la-south-2"
}

variable "apig_description" {
  description = "Descripción del API Gateway"
  type        = string
  default     = ""
}

variable "enterprise_project_id" {
  description = "ID del Enterprise Project"
  type        = string
  default     = "0"
}

variable "api_group_description" {
  description = "Descripción del grupo de APIs"
  type        = string
  default     = ""
}

variable "apig_stage_description" {
  description = "Descripción del stage"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {}
}

variable "apig_azs" {
  description = "Nombre de AZs"
  type        = list(string)
}

variable "apig_bandwith_size"{
  description = "Ancho de banda"
  type = string
  default = 5
}

variable "apig_ingress_bandwith_size"{
  description = "Ancho de banda del ingress"
  type = string
  default = 5
}

variable "apig_ingress_charging"{
  description = "Charging mode del ingress"
  type = string
  default = "bandwidth"
}
