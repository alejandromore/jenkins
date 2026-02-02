############################################
# Variables para módulo CCE Cluster
############################################

variable "cce_cluster_name" {
  description = "Nombre del cluster CCE."
  type        = string
}

variable "cce_cluster_type" {
  description = "Tipo de cluster CCE (VirtualMachine, BareMetal, etc)."
  type        = string
}

variable "cce_cluster_flavor" {
  description = "Flavor ID del cluster CCE (por ejemplo: cce.s2.small)."
  type        = string
}

variable "cce_k8s_version" {
  description = "Versión de Kubernetes para el cluster CCE (ej: 1.29)."
  type        = string
}

variable "cce_vpc_id" {
  description = "ID del VPC donde se creará el cluster."
  type        = string
}

variable "cce_subnet_id" {
  description = "ID de la Subnet principal utilizada por el cluster CCE."
  type        = string
}

variable "security_group_id" {
  description = "ID del Security Group asociado al cluster CCE."
  type        = string
}

variable "cce_network_type" {
  description = "Tipo de red del cluster (por ejemplo: vpc-router, overlay_l2, eni)."
  type        = string
}

variable "cce_network_cidr" {
  description = "CIDR del container network para los pods."
  type        = string
  default     = ""
}

variable "cce_authentication_mode" {
  description = "Modo de autenticación del cluster (rbac, authenticating_proxy, etc)."
  type        = string
}

variable "cce_eip" {
  description = "EIP asignado al cluster. Puede ser null si no se usa."
  type        = string
  default     = null
}

variable "cce_charging_mode" {
  description = "Modo de cobro del cluster (postPaid, prePaid)."
  type        = string
  default     = "postPaid"
}

variable "cce_availability_zone" {
  description = "Zona de disponibilidad del nodo master del cluster."
  type        = string
}

variable "cce_enteprise_project_id" {
  description = "Enterprise Project ID donde se creará el cluster."
  type        = string
}

variable "cce_eni_subnet_id" {
  description = "ID de la subnet utilizada para ENI (cuando la red es tipo eni)."
  type        = string
  default     = ""
}

variable "cce_eni_subnet_cidr" {
  description = "CIDR de la subnet ENI del cluster."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags a aplicar al cluster CCE."
  type        = map(string)
  default     = {}
}
