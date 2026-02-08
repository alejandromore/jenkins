variable "environment" {
  description = "Nombre del ambiente (noprod, prod)"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the ECS"
  type        = map(string)
  default     = {}
}

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

variable "vpc_name" {
  description = "Nombre de la vpc"
  type        = string
}

variable "vpc_cidr" {
  description = "cidr de la vpc"
  type        = string
}

variable "dns_list" {
  description = "dns_list"
  type        = list(string)
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE VPC Subnet
# ============================================================================
variable "security_group_public_name" {
  description = "Nombre del Grupo de Seguridad Public"
  type        = string
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE VPC Subnet
# ============================================================================

variable "vpc_subnet_public_name" {
  description = "Nombre de la subnet public"
  type        = string
}

variable "vpc_subnet_public_cidr" {
  description = "cidr de la subnet public"
  type        = string
}

variable "vpc_subnet_public_gateway_ip" {
  description = "gateway_ip de la subnet public"
  type        = string
}

# ============================================================================
# VARIABLES PARA LA INSTANCIA DE ECS
# ============================================================================

variable "ecs_public_name" {
  description = "Nombre del ECS"
  type        = string
  default = ""
}

# ============================================================================
# VARIABLES PARA EL AGENCY
# ============================================================================
variable "agency_name" {
  description = "Name of the IAM Agency"
  type        = string
  default     = ""
}

variable "agency_description" {
  description = "Description of the IAM Agency"
  type        = string
  default     = ""
}

variable "agency_delegated_service_name" {
  description = "Delegated service name"
  type        = string
  default     = "op_svc_csms"
}

variable "agency_duration" {
  description = "Duration"
  type        = string
  default     = "FOREVER"
}

