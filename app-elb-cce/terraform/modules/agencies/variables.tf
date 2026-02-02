# Agency Configuration
variable "name" {
  description = "Name of the IAM Agency"
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of the IAM Agency"
  type        = string
  default     = ""
}

variable "delegated_service_name" {
  description = "Delegated service name"
  type        = string
  default     = "op_svc_csms"
}

variable "duration" {
  description = "Duration"
  type        = string
  default     = "FOREVER"
}

variable "all_resources_roles" {
  description = "List of resource roles"
  type        = list(string)
  default     = []
}
