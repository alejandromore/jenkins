variable "name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project_id" {
  description = "Name of Project ID"
  type        = string
}

variable "tags" {
  description = "Tags to assign"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "Name of Region"
  type        = string
}

