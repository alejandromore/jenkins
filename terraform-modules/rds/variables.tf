variable "name" {
  type        = string
  description = "Name of the RDS instance"
}

variable "flavor" {
  type        = string
  description = "RDS flavor (compute class)"
}

variable "availability_zone" {
  description = "Availability Zone"
  type        = list(string)
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "enterprise_project_id" {
  type    = string
  default = null
}

variable "engine_version" {
  type        = string
  default     = "15"
  description = "PostgreSQL engine version"
}

variable "engine_type" {
  type        = string
  default     = "PostgreSQL"
  description = "PostgreSQL engine type"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database admin password"
}

variable "port" {
  type        = number
  default     = 5432
  description = "Database port"
}

variable "volume_type" {
  type        = string
  default     = "CLOUDSSD"
  description = "Disk type for RDS"
}

variable "volume_size" {
  type        = number
  default     = 100
  description = "Disk size in GB"
}

## Backup best practices
variable "backup_start_time" {
  type        = string
  default     = "01:00-02:00"
  description = "Preferred backup window"
}

variable "backup_keep_days" {
  type        = number
  default     = 7
  description = "How many days to keep backups"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

