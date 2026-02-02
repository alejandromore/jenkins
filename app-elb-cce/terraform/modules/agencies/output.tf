output "agency_id" {
  description = "The ID of the created IAM Agency"
  value       = huaweicloud_iam_agency.this.id
}

output "agency_name" {
  description = "The name of the created IAM Agency"
  value       = huaweicloud_iam_agency.this.name
}