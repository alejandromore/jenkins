# Configuración de FunctionGraph
variable "name" {
  description = "Nombre de la función FunctionGraph"
  type        = string
  default     = "java-event-function"
}

variable "runtime" {
  description = "Runtime de la función"
  type        = string
  default     = "Java21"
}

variable "memory_size" {
  description = "Tamaño de memoria en MB"
  type        = number
  default     = 512
}

variable "timeout" {
  description = "Timeout"
  type        = number
  default     = 30
}

variable "handler" {
  description = "Handler de la función"
  type        = string
  default     = "com.example.Function.handler"
}

variable "app" {
  description = "App name"
  type        = string
  default     = "Default"
}

variable "agency" {
  description = "Agencia de la función"
  type        = string
  default     = "none"
}

variable "code_type" {
  description = "Tipo de codigo"
  type        = string
  default     = "obs"
}

variable "code_url" {
  description = "URL del codigo"
  type        = string
  default     = ""
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
  default     = ""
}

variable "subnet_id" {
  type = string
  description = "Subnet ID"
  default     = ""
}

variable "network_id" {
  type        = string
  description = "FunctionGraph network ID"
  default     = ""
}

# Enterprise Project
variable "enterprise_project_id" {
  description = "ID del Enterprise Project"
  type        = string
  default     = ""
}

# Tags
variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {}
}