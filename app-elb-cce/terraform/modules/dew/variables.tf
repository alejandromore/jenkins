variable "secret_name" {
  description = "Name of the DEW secret"
  type        = string
}

variable "secret_description" {
  description = "Description of the secret"
  type        = string
  default     = "Secret managed by Terraform"
}

variable "secret_payload" {
  description = "Secret content in JSON format"
  type        = map(string)
  sensitive   = true
}

variable "enterprise_project_id" {
  description = "Enterprise Project ID"
  type        = string
}