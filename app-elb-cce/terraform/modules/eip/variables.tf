variable "eip_name" {
  default = ""
}

variable "eip_id" {
  default = ""
}

variable "bandwidth_name" {
  default = "default-bandwidth"
}

variable "enterprise_project_id" {
  description = "Enterprise Project iD"
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

